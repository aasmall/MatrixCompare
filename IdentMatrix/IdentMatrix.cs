using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using Microsoft.SqlServer.Server;


namespace IdentMatrix
{
    public interface IMatrixDataSource
    {
        void ImportRows();
    }

    public class IdentRow
    {
        Int32 DSType;
        Int32 Ident;
        String NormalizedName;
        String OrignalName;
        String CompareMetadata;
        public IdentRow(Int32 dstype,  Int32 ident, String normalizedName, String orignalName,String compareMetadata)
        {
            this.DSType = dstype;
            this.Ident = ident;
            this.NormalizedName = normalizedName;
            this.OrignalName = orignalName;
            this.CompareMetadata = compareMetadata;
        }
        public void StoreRow()
        {
            
            using (MatrixDatasetTableAdapters.QueriesTableAdapter qt = new MatrixDatasetTableAdapters.QueriesTableAdapter() )
            {
                qt.ImportDS(this.DSType, this.Ident, this.NormalizedName, this.OrignalName, this.CompareMetadata);
            }
        }
    }
    [FileHelpers.DelimitedRecord(",")]
    public class GitUser
    {
        public int ident;
        public string name;
        public string role;
    }
    [FileHelpers.DelimitedRecord(",")]
    public class Alerts
    {
        public Alerts() { }
        public Alerts(string message)
        {
            this.dt = DateTime.Now.ToString("HH:mm:ss tt");
            this.Message = message;
        }
        public string dt;
        public string Message;
    }
    [FileHelpers.DelimitedRecord(",")]
    public class ADUser
    {
        public int ident;
        public string name;
        public string role;
    }
    public class TextGITDataSource : IMatrixDataSource
    {
        String dataLocation = @"c:\users\aaron\documents\visual studio 2013\Projects\IdentMatrix\IdentMatrix\SampleTxtGIT.txt";
        Int32 DSType = 1;
        private String normalizeRole(string role)
        {
            return role;
        }

        public void ImportRows()
        {
            FileHelpers.FileHelperEngine engine = 
                new FileHelpers.FileHelperEngine(typeof(GitUser));
            GitUser[] res = engine.ReadFile(dataLocation) as GitUser[];
            List<IdentRow> users = new List<IdentRow>();
            foreach (GitUser user in res)
            {
                new IdentRow(DSType, user.ident, user.name, user.name, normalizeRole(user.role)).StoreRow();
            }
        }
    }
    public class TextADDataSource : IMatrixDataSource
    {
        String dataLocation = @"c:\users\aaron\documents\visual studio 2013\Projects\IdentMatrix\IdentMatrix\SampleTxtAD.txt";
        Int32 DSType = 2;
        private String normalizeRole(string role)
        {
            return role;
        }
        public void ImportRows()
        {
            FileHelpers.FileHelperEngine engine =
                new FileHelpers.FileHelperEngine(typeof(GitUser));
            GitUser[] res = engine.ReadFile(dataLocation) as GitUser[];
            List<IdentRow> users = new List<IdentRow>();
            foreach (GitUser user in res)
            {
                new IdentRow(DSType, user.ident, user.name, user.name, normalizeRole(user.role)).StoreRow();
            }
        }
    }
   
    public partial class IdentMatrix : ServiceBase
    {
        private System.Threading.Timer IntervalTimer;
        public void onDebug()
        {
            OnStart(null);
        }
        public IdentMatrix()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            //TimeSpan tsInterval = new TimeSpan(0, 0, 10);
            //IntervalTimer = new System.Threading.Timer(
            //    new System.Threading.TimerCallback(IntervalTimer_Elapsed)
            //    , null, tsInterval, tsInterval);
            DoWork();
        }

        protected override void OnStop()
        {
            IntervalTimer.Change(System.Threading.Timeout.Infinite, System.Threading.Timeout.Infinite);
            IntervalTimer.Dispose();
            IntervalTimer = null;
        }
        private void IntervalTimer_Elapsed(object state)
        {   
            DoWork();
        }
        private void DoWork()
        {
            String OutPath = @"C:\Users\Aaron\Documents\Visual Studio 2013\Projects\IdentMatrix\IdentMatrix\alerts.txt";

            TextADDataSource ad = new TextADDataSource();
            TextGITDataSource git = new TextGITDataSource();
            ad.ImportRows();
            git.ImportRows();

            FileHelpers.FileHelperEngine engine = new FileHelpers.FileHelperEngine(typeof(Alerts));
            engine.AppendToFile(OutPath,new Alerts("Hi"));


        }
    }
}
