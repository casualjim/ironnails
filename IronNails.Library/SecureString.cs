using System;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;

namespace IronNails.Helpers
{
//    public class SecureString
//    {
//        private static readonly byte[] entropy = Encoding.Unicode.GetBytes("SylvesterPasswordSalt");
//
//        public static string EncryptString(System.Security.SecureString input)
//        {
//            var encryptedData = ProtectedData.Protect(
//                Encoding.Unicode.GetBytes(ToInsecureString(input)),
//                entropy,
//                DataProtectionScope.CurrentUser);
//            return Convert.ToBase64String(encryptedData);
//        }
//
//        public static System.Security.SecureString ToSecureString(string input)
//        {
//            var secure = new System.Security.SecureString();
//            foreach (var c in input)
//            {
//                secure.AppendChar(c);
//            }
//            secure.MakeReadOnly();
//            return secure;
//        }
//
//        public static string ToInsecureString(System.Security.SecureString input)
//        {
//            string returnValue;
//            var ptr = Marshal.SecureStringToBSTR(input);
//            try
//            {
//                returnValue = Marshal.PtrToStringBSTR(ptr);
//            }
//            finally
//            {
//                Marshal.ZeroFreeBSTR(ptr);
//            }
//            return returnValue;
//        }
//
//        public static System.Security.SecureString DecryptString(string encryptedData)
//        {
//            try
//            {
//                var decryptedData = ProtectedData.Unprotect(
//                    Convert.FromBase64String(encryptedData),
//                    entropy,
//                    DataProtectionScope.CurrentUser);
//                return ToSecureString(Encoding.Unicode.GetString(decryptedData));
//            }
//            catch
//            {
//                return new System.Security.SecureString();
//            }
//        }
//    }
}