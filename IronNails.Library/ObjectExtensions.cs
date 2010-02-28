namespace IronNails.Library
{
    internal static class ObjectExtensions
    {
        public static bool IsNull(this object target)
        {
            return target == null;
        }

        public static bool IsNotNull(this object target)
        {
            return target != null;
        }
    }
}