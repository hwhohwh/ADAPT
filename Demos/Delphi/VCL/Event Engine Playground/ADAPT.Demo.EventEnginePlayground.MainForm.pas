unit ADAPT.Demo.EventEnginePlayground.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  ADAPT.EventEngine.Intf;

type
  TMainForm = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  ADAPT.Demo.EventEnginePlayground.Events;

{$R *.dfm}

procedure TMainForm.Button1Click(Sender: TObject);
var
  LEvent: IADEvent;
begin
  LEvent := TTestEvent.Create(Edit1.Text);
  LEvent.Queue;
end;

end.
