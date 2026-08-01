// tmux-coder OpenCode plugin.
//
// When OpenCode runs inside a tmux-coder-managed pane, this plugin reports the
// agent's activity to the tmux-coder daemon so its status shows up in the TUI.

import { appendFileSync } from "node:fs";

const AGENT_ID = process.env.TMUX_CODER_AGENT_ID;
const DEBUG = process.env.TMUX_CODER_PLUGIN_DEBUG;

function debug(line) {
  if (!DEBUG) return;
  try {
    appendFileSync(DEBUG, line + "\n");
  } catch {}
}

function daemonBaseURL(raw) {
  if (!raw) return "http://127.0.0.1:64357";
  if (raw.includes("://")) return raw;
  return "http://" + raw;
}

const WAITING_EVENTS = new Set(["permission.asked", "question.asked"]);
const REPLY_EVENTS = new Set([
  "permission.replied",
  "question.replied",
  "question.rejected",
]);
const statusByEvent = {
  "session.idle": "idle",
  "message.part.updated": "busy",
};

export const TmuxCoderStatus = async () => {
  if (!AGENT_ID) return {};

  const eventURL = `${daemonBaseURL(process.env.TMUX_CODERD_ADDR)}/agents/${AGENT_ID}/event`;
  let lastStatus = "";
  const childSessions = new Set();
  let blocked = false;

  function report(status) {
    debug(`report ${status} (last=${lastStatus})`);
    if (status === lastStatus) return;
    lastStatus = status;

    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), 1000);
    fetch(eventURL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ event: status }),
      signal: controller.signal,
    })
      .catch(() => {})
      .finally(() => clearTimeout(timer));
  }

  report("idle");

  return {
    event: async ({ event }) => {
      const type = event?.type;
      debug(`event ${type}`);

      if (type === "session.created" || type === "session.updated") {
        const info = event.properties?.info;
        if (info?.parentID) childSessions.add(info.id);
        else if (info?.id) childSessions.delete(info.id);
      } else if (type === "session.deleted") {
        childSessions.delete(event.properties?.info?.id);
      }

      if (type === "session.idle" && childSessions.has(event.properties?.sessionID)) return;

      if (WAITING_EVENTS.has(type)) {
        blocked = true;
        report("waiting");
        return;
      }
      if (REPLY_EVENTS.has(type)) {
        blocked = false;
        report("busy");
        return;
      }

      const status = statusByEvent[type];
      if (!status) return;
      if (status === "idle") blocked = false;
      if (blocked) return;
      report(status);
    },
    "chat.message": async () => {
      if (!blocked) report("busy");
    },
    "tool.execute.before": async () => {
      if (!blocked) report("busy");
    },
  };
};
