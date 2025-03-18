const fs = require('fs');
const yaml = require('js-yaml');
const xml2js = require('xml2js');
const csv = require('csv-parser');

// Read JSON File
function readJson(filePath) {
    const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    console.log("JSON Data:", data);
}

// Read XML File
function readXml(filePath) {
    const xml = fs.readFileSync(filePath, 'utf8');
    xml2js.parseString(xml, (err, result) => {
        if (err) throw err;
        console.log("XML Data:", result);
    });
}

// Read TXT File
function readTxt(filePath) {
    const data = fs.readFileSync(filePath, 'utf8');
    console.log("TXT Data:", data);
}

// Read YAML File
function readYaml(filePath) {
    const data = yaml.load(fs.readFileSync(filePath, 'utf8'));
    console.log("YAML Data:", data);
}

// Read CSV File
function readCsv(filePath) {
    console.log("CSV Data:");
    fs.createReadStream(filePath)
        .pipe(csv())
        .on('data', (row) => {
            console.log(row);
        })
        .on('end', () => {
            console.log('CSV file successfully processed');
        });
}

// Execute functions
readJson('json.json');
readXml('xml.xml');
readTxt('txt.txt');
readYaml('yaml.yaml');
readCsv('csv.csv');