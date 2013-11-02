using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace IdentMatrix
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main()
        {        
        #if DEBUG
            //While debugging this section is used.
            IdentMatrix myService = new IdentMatrix();
            myService.onDebug();
            System.Threading.Thread.Sleep(System.Threading.Timeout.Infinite);
        #else
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[] 
            { 
                new IdentMatrix() 
            };
            ServiceBase.Run(ServicesToRun);
        #endif
        }
    }
}
