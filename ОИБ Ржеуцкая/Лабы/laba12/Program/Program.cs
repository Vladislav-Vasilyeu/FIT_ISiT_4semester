using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Collections;

class Program
{
    static void Main()
    {
        string lastName = "Васильев"; 
        byte[] data = Encoding.UTF8.GetBytes(lastName);

        // === RSA 512 бит ===
        using (RSA rsa = RSA.Create(512))
        {
            Console.WriteLine(">>> Генерация ключей RSA...");
            byte[] publicKey = rsa.ExportRSAPublicKey();
            byte[] privateKey = rsa.ExportRSAPrivateKey();
            File.WriteAllBytes("public.key", publicKey);
            File.WriteAllBytes("private.key", privateKey);

            Console.WriteLine(">>> Шифрование фамилии...");
            byte[] encrypted = rsa.Encrypt(data, RSAEncryptionPadding.Pkcs1);
            File.WriteAllBytes("encrypted.txt", encrypted);

            Console.WriteLine(">>> Расшифровка...");
            byte[] decrypted = rsa.Decrypt(encrypted, RSAEncryptionPadding.Pkcs1);
            string decryptedText = Encoding.UTF8.GetString(decrypted);
            Console.WriteLine("Расшифрованный текст: " + decryptedText);
            File.WriteAllText("decrypted.txt", decryptedText);
        }

        // === MD5 Хеширование ===
        Console.WriteLine(">>> Хеширование фамилии с помощью MD5...");
        using (MD5 md5 = MD5.Create())
        {
            byte[] hash = md5.ComputeHash(data);
            File.WriteAllBytes("hash.txt", hash);
            Console.WriteLine("Хеш MD5: " + BitConverter.ToString(hash).Replace("-", ""));
        }

        // === Проверка целостности (по примеру ЭЦП) ===
        Console.WriteLine(">>> Проверка целостности сообщения и хеша...");
        byte[] originalHash = File.ReadAllBytes("hash.txt");
        byte[] currentHash;

        using (MD5 md5 = MD5.Create())
        {
            currentHash = md5.ComputeHash(data);
        }

        bool isValid = StructuralComparisons.StructuralEqualityComparer.Equals(originalHash, currentHash);
        Console.WriteLine(isValid ? "Целостность подтверждена." : "Целостность нарушена!");

        Console.WriteLine("\n>>> Демонстрация нарушения целостности (изменим сообщение)");
        string tamperedMessage = lastName + "X";
        byte[] tamperedData = Encoding.UTF8.GetBytes(tamperedMessage);
        byte[] tamperedHash;
        using (MD5 md5_2 = MD5.Create())
        {
            tamperedHash = md5_2.ComputeHash(tamperedData);
        }
        bool tamperedValid = StructuralComparisons.StructuralEqualityComparer.Equals(originalHash, tamperedHash);
        Console.WriteLine(tamperedValid ? "Целостность подтверждена (ОШИБКА)." : "Целостность нарушена (ОЖИДАЕМО).");
    }
}
