const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

function encryptMessage(message, cols){
    message = message.replace(/\s/g, '').toUpperCase();

    const length = message.length;
    const rows = Math.ceil(length / cols);
    const totalLength = rows * cols;

    message = message.padEnd(totalLength, ' ');

    const matrix = [];
    let index = 0;
    for( let r = 0; r < rows; r++){
        const row = [];
        for(let c = 0; c < cols; c++){
            row.push(message[index++]);
        }
        matrix.push(row);
    }

    let encrypted = '';
    for (let c = 0; c < cols; c++){
        for(let r = 0; r < rows; r++){
            encrypted += matrix[r][c];
        }
    }
    return encrypted;
}

rl.question("Введите сообщение для шифрования: ", function (inputMessage) {
    rl.question("Введите количество столбцов: ", function (inputCols) {
        const cols = parseInt(inputCols);

        if (isNaN(cols) || cols <= 0) {
            console.log("Ошибка: количество столбцов должно быть положительным числом.");
        } else {
            const encrypted = encryptMessage(inputMessage, cols);
            console.log("\nЗашифрованное сообщение:", encrypted);
        }

        rl.close();
    });
});