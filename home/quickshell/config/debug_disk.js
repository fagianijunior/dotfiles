// Script de debug para testar a lógica de processamento de discos
// Simula o que acontece no QML

let testOutput = `/:7
/boot:6`;

let lines = testOutput.trim().split('\n');
let colors = ["#cba6f7", "#fab387", "#89b4fa", "#a6e3a1", "#f38ba8"];
let diskModel = [];

console.log("=== Debug Disk Processing ===");
console.log("Input lines:", lines);

for (let i = 0; i < lines.length && i < colors.length; i++) {
    let line = lines[i].trim();
    console.log(`Processing line ${i}: "${line}"`);
    
    if (line === "") {
        console.log("  -> Skipping empty line");
        continue;
    }
    
    let parts = line.split(':');
    console.log("  -> Parts:", parts);
    
    if (parts.length !== 2) {
        console.log("  -> Skipping: not 2 parts");
        continue;
    }
    
    let mountPoint = parts[0];
    let usage = parseInt(parts[1]);
    
    console.log(`  -> Mount: "${mountPoint}", Usage: ${usage}`);
    
    // Testa os filtros
    let startsWithSlash = mountPoint.startsWith("/");
    let hasSnap = mountPoint.includes("snap");
    let hasLoop = mountPoint.includes("loop");
    let lengthOk = mountPoint.length < 20;
    
    console.log(`  -> Filters: startsWith/=${startsWithSlash}, !snap=${!hasSnap}, !loop=${!hasLoop}, length<20=${lengthOk}`);
    
    if (startsWithSlash && !hasSnap && !hasLoop && lengthOk) {
        let item = {
            mountPoint: mountPoint,
            usage: usage,
            color: colors[i % colors.length]
        };
        diskModel.push(item);
        console.log("  -> ADDED:", item);
    } else {
        console.log("  -> FILTERED OUT");
    }
}

console.log("\n=== Final Result ===");
console.log("Disk model:", diskModel);
console.log("Count:", diskModel.length);