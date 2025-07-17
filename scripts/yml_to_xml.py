#!/usr/bin/env python3
import argparse
import yaml
import xml.etree.ElementTree as ET
from xml.dom import minidom
import os
import sys
import subprocess


def convert_lists_to_dicts(data, parent_key=None):
    """
    Recursively convert lists to dictionaries with keys inherited from parent element.
    List items get keys in the format 'parent-item'.
    """
    if isinstance(data, dict):
        result = {}
        for key, value in data.items():
            result[key] = convert_lists_to_dicts(value, key)
        return result
    elif isinstance(data, list):
        result = {}
        item_key = f"{parent_key}-item" if parent_key else "item"
        for i, item in enumerate(data):
            # Use the same key for all items in the list
            if item_key in result:
                # If key already exists, make it a list
                if not isinstance(result[item_key], list):
                    result[item_key] = [result[item_key]]
                result[item_key].append(convert_lists_to_dicts(item, item_key))
            else:
                result[item_key] = convert_lists_to_dicts(item, item_key)
        return result
    else:
        return data


def dict_to_xml(data, root_name="root"):
    """
    Convert a dictionary to XML ElementTree.
    """
    root = ET.Element(root_name)
    
    def add_elements(parent, data):
        if isinstance(data, dict):
            for key, value in data.items():
                if isinstance(value, list):
                    # Handle lists by creating multiple elements with the same tag
                    for item in value:
                        elem = ET.SubElement(parent, key)
                        add_elements(elem, item)
                else:
                    elem = ET.SubElement(parent, key)
                    add_elements(elem, value)
        else:
            parent.text = str(data)
    
    add_elements(root, data)
    return root


def prettify_xml(elem):
    """
    Return a pretty-printed XML string for the Element.
    """
    rough_string = ET.tostring(elem, 'unicode')
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="  ")


def copy_to_clipboard(text):
    """
    Copy text to clipboard using xclip.
    """
    try:
        subprocess.run(['xclip', '-selection', 'clipboard'], input=text, text=True, check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        try:
            subprocess.run(['xsel', '--clipboard', '--input'], input=text, text=True, check=True)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            return False


def main():
    parser = argparse.ArgumentParser(description="Convert YAML to XML with list-to-dict conversion")
    parser.add_argument("yaml_file", nargs="?", default="/tmp/prompt.yml",
                        help="Path to input YAML file (default: /tmp/prompt.yml)")
    parser.add_argument("xml_file", nargs="?", default="/tmp/prompt.xml",
                        help="Path to output XML file (default: /tmp/prompt.xml)")
    parser.add_argument("--no-clipboard", action="store_true",
                        help="Do not copy XML output to clipboard")
    
    args = parser.parse_args()
    
    # Check if input file exists
    if not os.path.exists(args.yaml_file):
        print(f"Error: Input file '{args.yaml_file}' does not exist.", file=sys.stderr)
        sys.exit(1)
    
    try:
        # Read and parse YAML file
        with open(args.yaml_file, 'r', encoding='utf-8') as file:
            yaml_data = yaml.safe_load(file)
        
        if yaml_data is None:
            print(f"Error: YAML file '{args.yaml_file}' is empty or invalid.", file=sys.stderr)
            sys.exit(1)
        
        # Convert lists to dictionaries
        converted_data = convert_lists_to_dicts(yaml_data)
        
        # Convert to XML
        xml_root = dict_to_xml(converted_data, "root")
        
        # Create output directory if it doesn't exist
        output_dir = os.path.dirname(args.xml_file)
        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir)
        
        # Write XML to file
        xml_string = prettify_xml(xml_root)
        with open(args.xml_file, 'w', encoding='utf-8') as file:
            file.write(xml_string)
        
        print(f"Successfully converted '{args.yaml_file}' to '{args.xml_file}'")
        
        # Copy to clipboard by default unless disabled
        if not args.no_clipboard:
            if copy_to_clipboard(xml_string):
                print("XML content copied to clipboard")
            else:
                print("Warning: Could not copy to clipboard. Please install xclip or xsel.", file=sys.stderr)
        
    except yaml.YAMLError as e:
        print(f"Error parsing YAML file: {e}", file=sys.stderr)
        sys.exit(1)
    except IOError as e:
        print(f"Error reading/writing file: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()