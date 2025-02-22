unit UFrmPrincipalImpl;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtDocumentoCliente: TLabeledEdit;
    cmbTamanhoPizza: TComboBox;
    cmbSaborPizza: TComboBox;
    Button1: TButton;
    mmRetornoWebService: TMemo;
    edtEnderecoBackend: TLabeledEdit;
    TabSheet2: TTabSheet;
    Label6: TLabel;
    edtDocumentoPesquisa: TLabeledEdit;
    Button2: TButton;
    mmConsulta: TMemo;
    edtEnderecoBackendConsulta: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  WSDLPizzariaBackendControllerImpl,
  Rtti,
  REST.JSON,
  UPizzaTamanhoEnum,
  UPizzaSaborEnum,
  UPedidoRetornoDTOImpl;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  oPizzariaBackendController: IPizzariaBackendController;
begin
   oPizzariaBackendController := WSDLPizzariaBackendControllerImpl.GetIPizzariaBackendController(edtEnderecoBackend.Text);
   mmRetornoWebService.Text := TJson.ObjectToJsonString(oPizzariaBackendController.efetuarPedido(TRttiEnumerationType.GetValue<TPizzaTamanhoEnum>(cmbTamanhoPizza.Text), TRttiEnumerationType.GetValue<TPizzaSaborEnum>(cmbSaborPizza.Text), edtDocumentoCliente.Text));
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  oPizzariaBackendController: IPizzariaBackendController;

  oDTOPedido : TPedidoRetornoDTO;
begin
   oPizzariaBackendController := WSDLPizzariaBackendControllerImpl.GetIPizzariaBackendController(edtEnderecoBackendConsulta.Text);

   oDTOPedido := oPizzariaBackendController.consultarPedido(edtDocumentoPesquisa.Text);
   mmConsulta.Clear;

   mmConsulta.Lines.Add( 'DETALHES DO �LTIMO PEDIDO DO CLIENTE');
   mmConsulta.Lines.Add( '===============================');
   mmConsulta.Lines.Add('Tamanho: '+UpperCase(Copy(TRttiEnumerationType.GetName<TPizzaTamanhoEnum>(oDTOPedido.PizzaTamanho),
    3,length(TRttiEnumerationType.GetName<TPizzaTamanhoEnum>(oDTOPedido.PizzaTamanho)))));
   mmConsulta.Lines.Add('Sabor : '+UpperCase(Copy(TRttiEnumerationType.GetName<TPizzaSaborEnum>(oDTOPedido.PizzaSabor),3,
   length(TRttiEnumerationType.GetName<TPizzaSaborEnum>(oDTOPedido.PizzaSabor)))));
   mmConsulta.Lines.Add('Pre�o : '+ FormatCurr('R$0.00',oDTOPedido.ValorTotalPedido));
   mmConsulta.Lines.Add('Tempo : '+ oDTOPedido.TempoPreparo.ToString + ' minutos.');
   mmConsulta.Lines.Add( '===============================');
end;

end.
