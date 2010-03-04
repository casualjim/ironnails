using System.Collections.Generic;
using System.IO;
using IronRuby;
using IronRuby.Builtins;
using IronRuby.Runtime;
using Microsoft.Scripting.Hosting;

namespace IronNails.Library
{
    public class DlrHelper
    {
        private static ScriptRuntime _scriptRuntime;
        
        public DlrHelper()
        {
            InitializeRubyEngine();
            AddLoadPaths();
        }

        public static ScriptRuntime Runtime
        {
            get
            {
                if (_scriptRuntime.IsNotNull()) return _scriptRuntime;

                var setup = new ScriptRuntimeSetup();
                setup.LanguageSetups.Add(Ruby.CreateRubySetup());
                return (_scriptRuntime = Ruby.CreateRuntime(setup));
            }
            set { _scriptRuntime = value; }
        }

        public static string AppRoot { get; set; }
        public static ICollection<string> LoadPaths { get; set; }

        public ScriptEngine Engine { get; private set; }
        public RubyContext Context { get; private set; }
        public ObjectOperations Operations { get; private set; }

        public object LoadObject(string fileName)
        {
            var nm = Path.GetFileNameWithoutExtension(fileName).Underscore();
            Engine.RequireFile(fileName);
            var klass = Runtime.Globals.GetVariable<RubyClass>(nm.Pascalize());
            return Operations.CreateInstance(klass);
        }

        public object CallMethod(object target, string method, params object[] args)
        {
            return Operations.InvokeMember(target, method, args);
        }

        public string RootPath(string path, string filename)
        {
            return string.Format("{0}/{1}/{2}", AppRoot, path, filename);
        }

        private void AddLoadPaths()
        {
            Engine.SetSearchPaths(LoadPaths);
        }

        public object ExecuteScript(string script)
        {
            return Engine.Execute(script);
        }

        private void InitializeRubyEngine()
        {
            Engine = Ruby.GetEngine(Runtime);
            Operations = Engine.CreateOperations();
        }
    }
}