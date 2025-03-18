import json
import xml.etree.ElementTree as ET
import yaml
import csv

def read_json(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    print("JSON Data:", data)


def read_xml(file_path):
    tree = ET.parse(file_path)
    root = tree.getroot()
    print("XML Data:")
    for elem in root:
        print(elem.tag, elem.text)


def read_txt(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = f.read()
    print("TXT Data:", data)


def read_yaml(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = yaml.safe_load(f)
    print("YAML Data:", data)


def read_csv(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        print("CSV Data:")
        for row in reader:
            print(row)


if __name__ == "__main__":
    read_json("json.json")
    read_xml("xml.xml")
    read_txt("txt.txt")
    read_yaml("yaml.yaml")
    read_csv("csv.csv")
