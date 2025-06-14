const { webcrypto } = require('node:crypto');
const crypto = webcrypto;
const encoder = new TextEncoder();
const decoder = new TextDecoder();

// 1. Генерация случайных чисел
function generateRandomNumbers() {
  console.log('\n--- СЛУЧАЙНЫЕ ЧИСЛА ---');
  const randomArray = crypto.getRandomValues(new Uint32Array(5));
  console.log('Случайные числа:', [...randomArray].join(', '));
}

// 2. AES-GCM шифрование и SHA-512 хеширование
async function encryptDecryptHash() {
  console.log('\n--- AES-GCM ШИФРОВАНИЕ И SHA-512 ХЕШ ---');
  const data = encoder.encode("Васильев");

  // Генерация AES-ключа
  const aesKey = await crypto.subtle.generateKey(
    { name: "AES-GCM", length: 256 },
    true,
    ["encrypt", "decrypt"]
  );

  const iv = crypto.getRandomValues(new Uint8Array(12)); // Инициализирующий вектор (IV)
  const encrypted = await crypto.subtle.encrypt({ name: "AES-GCM", iv }, aesKey, data);
  const decrypted = await crypto.subtle.decrypt({ name: "AES-GCM", iv }, aesKey, encrypted);

  console.log("Зашифровано (base64):", Buffer.from(encrypted).toString('base64'));
  console.log("Расшифровано:", decoder.decode(decrypted));

  // Хеширование
  const hashBuffer = await crypto.subtle.digest("SHA-512", data);
  const hashHex = Array.from(new Uint8Array(hashBuffer)).map(b => b.toString(16).padStart(2, '0')).join('');
  console.log("SHA-512 хеш:", hashHex);

  return aesKey;
}

// 3. Упаковка и распаковка ключа с помощью AES-KW
async function wrapUnwrapKey(keyToWrap) {
  console.log('\n--- AES-KW УПАКОВКА И РАСПАКОВКА ---');

  // Генерация ключа-обертки
  const wrappingKey = await crypto.subtle.generateKey(
    { name: "AES-KW", length: 256 },
    true,
    ["wrapKey", "unwrapKey"]
  );

  // Упаковка
  const wrappedKey = await crypto.subtle.wrapKey(
    "raw",
    keyToWrap,
    wrappingKey,
    "AES-KW"
  );
  console.log("Упакованный ключ (base64):", Buffer.from(wrappedKey).toString('base64'));

  // Распаковка
  const unwrappedKey = await crypto.subtle.unwrapKey(
    "raw",
    wrappedKey,
    wrappingKey,
    "AES-KW",
    { name: "AES-GCM", length: 256 },
    true,
    ["encrypt", "decrypt"]
  );

  return unwrappedKey;
}

// 4. Подпись и проверка с использованием RSA-PSS
async function rsaPssSignVerify() {
  console.log('\n--- RSA-PSS ПОДПИСЬ И ПРОВЕРКА ---');

  // Генерация пары ключей
  const { publicKey, privateKey } = await crypto.subtle.generateKey(
    {
      name: "RSA-PSS",
      modulusLength: 2048,
      publicExponent: new Uint8Array([1, 0, 1]),
      hash: "SHA-256"
    },
    true,
    ["sign", "verify"]
  );

  const message = encoder.encode("Васильев");
  const signature = await crypto.subtle.sign(
    { name: "RSA-PSS", saltLength: 32 },
    privateKey,
    message
  );

  const isValid = await crypto.subtle.verify(
    { name: "RSA-PSS", saltLength: 32 },
    publicKey,
    signature,
    message
  );

  console.log("Подпись (base64):", Buffer.from(signature).toString('base64'));
  console.log("Подпись действительна:", isValid);
}

// ===== Запуск всех процедур =====
(async () => {
  generateRandomNumbers();
  const aesKey = await encryptDecryptHash();
  await wrapUnwrapKey(aesKey);
  await rsaPssSignVerify();
})();
