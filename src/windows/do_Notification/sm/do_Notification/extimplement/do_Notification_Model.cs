using doCore;
using doCore.Helper.JsonParse;
using doCore.Interface;
using doCore.Object;
using System;
using System.Threading.Tasks;
using Windows.UI.Notifications;
using Windows.UI.Popups;

namespace do_Notification.extimplement
{
    /// <summary>
    /// 自定义扩展API组件Model实现，继承DoSingletonModule抽象类，并实现@TYPEID_IMethod接口方法；
    /// #如何调用组件自定义事件？可以通过如下方法触发事件：
    /// this.model.getEventCenter().fireEvent(_messageName, jsonResult);
    /// 参数解释：@_messageName字符串事件名称，@jsonResult传递事件参数对象；
    /// 获取DoInvokeResult对象方式this.model.getCurrentPage().getScriptEngine().createInvokeResult(model.getUniqueKey());
    /// </summary>
    public class do_Notification_Model : doSingletonModule
    {
        public do_Notification_Model()
            : base()
        {

        }
        public override async Task<bool> InvokeAsyncMethod(string _methodName, doCore.Helper.JsonParse.doJsonNode _dictParas, doCore.Interface.doIScriptEngine _scriptEngine, string _callbackFuncName)
        {
            doInvokeResult _invokeResult = _scriptEngine.CreateInvokeResult(this.UniqueKey);
            if ("alert".Equals(_methodName))
            {
                this.alert(_dictParas, _scriptEngine, _invokeResult, _callbackFuncName);
                return true;
            }
            if ("confirm".Equals(_methodName))
            {
                this.confirm(_dictParas, _scriptEngine, _invokeResult, _callbackFuncName);
                return true;
            }
            if ("toast".Equals(_methodName))
            {
                this.toast(_dictParas, _scriptEngine, _invokeResult, _callbackFuncName);
                return true;
            }
            return await base.InvokeAsyncMethod(_methodName, _dictParas, _scriptEngine, _callbackFuncName);
        }
        public override bool InvokeSyncMethod(string _methodName, doCore.Helper.JsonParse.doJsonNode _dictParas, doCore.Interface.doIScriptEngine _scriptEngine, doInvokeResult _invokeResult)
        {
            return base.InvokeSyncMethod(_methodName, _dictParas, _scriptEngine, _invokeResult);
        }

        private async void alert(doJsonNode _dictParas, doIScriptEngine _scriptEngine, doInvokeResult _invokeResult, string _callbackFuncName)
        {
            try
            {
                string _title = _dictParas.GetOneText("title", "");
                string _content = _dictParas.GetOneText("text", "");
                await new MessageDialog(_content, _title).ShowAsync();
            }
            catch (Exception _err)
            {
                doServiceContainer.LogEngine.WriteError("doNotification alert \n", _err);
            }
        }
        private async void confirm(doJsonNode _dictParas, doIScriptEngine _scriptEngine, doInvokeResult _invokeResult, string _callbackFuncName)
        {
            try
            {
                string _title = _dictParas.GetOneText("title", "");
                string _content = _dictParas.GetOneText("text", "");
                string _button1text = _dictParas.GetOneText("button1text", "");
                string _button2text = _dictParas.GetOneText("button2text", "");
                MessageDialog md = new MessageDialog("");
                md.Content = _content;
                md.Title = _title;
                md.Commands.Add(new UICommand(_button1text, new UICommandInvokedHandler((e) =>
                {
                    _invokeResult.SetResultText("1");
                    if (!string.IsNullOrEmpty(_callbackFuncName))
                    {
                        _scriptEngine.Callback(_callbackFuncName, _invokeResult);
                    }
                })));
                md.Commands.Add(new UICommand(_button2text, new UICommandInvokedHandler((e) =>
                {
                    _invokeResult.SetResultText("2");
                    if (!string.IsNullOrEmpty(_callbackFuncName))
                    {
                        _scriptEngine.Callback(_callbackFuncName, _invokeResult);
                    }
                })));
                await md.ShowAsync();
            }
            catch (Exception _err)
            {
                doServiceContainer.LogEngine.WriteError("doNotification confirm \n", _err);
            }
        }
        private void toast(doJsonNode _dictParas, doIScriptEngine _scriptEngine, doInvokeResult _invokeResult, string _callbackFuncName)
        {
            //弹出toast窗口
            try
            {
                string _content = _dictParas.GetOneText("text", "");
                //var toastXmlString = "<toast><visual version='1'><binding template='ToastText01'><text id='1'>Body text that wraps over three lines</text></binding></visual></toast>";
                var toastXmlString = "<toast>"
                                   + "<visual version='1'>"
                                   + "<binding template='ToastText01'>"
                                   + "<text id='1'>" + _content + "</text>"
                                   + "</binding>"
                                   + "</visual>"
                                   + "</toast>";
                Windows.Data.Xml.Dom.XmlDocument toastDOM = new Windows.Data.Xml.Dom.XmlDocument();
                toastDOM.LoadXml(toastXmlString);

                // Create a toast, then create a ToastNotifier object to show
                // the toast
                ToastNotification toast = new ToastNotification(toastDOM);

                // If you have other applications in your package, you can specify the AppId of
                // the app to create a ToastNotifier for that application
                ToastNotificationManager.CreateToastNotifier().Show(toast);
            }
            catch (Exception _err)
            {
                doServiceContainer.LogEngine.WriteError("doNotification toast \n", _err);
            }
        }        
    
    }
}
