{*******************************************************************************
* Embardacero Delphi Visual Component                                          *
* PopUpMenuMob for Mobile devices                                              *
********************************************************************************
* Componente Criado Por Ruan Diego Lacerda Menezes & Douglas Colombo           *
* Copyright (C) 2018                                                           *
*******************************************************************************}

unit PopupMenu.Mob;

interface

uses
  FMX.Layouts, // Serve para o TLayout
  FMX.Objects, // Serve para o TRetangle  TAlignLayout
  System.Classes, // Serve para o TComponent
  System.UITypes, // Serve para o Cores...
  FMX.Types, // Serve para o TPosition
  FMX.Graphics, // Serve para TAlphaColor
  FMX.StdCtrls, // Serve para TLabel
  FMX.ListBox, // Serve para o ListBox
  System.Generics.Collections, // Collections
  System.SysUtils, //FreeAndNill...
  FMX.Ani, PopupMenu.Constantes; // serve para o TFloatAnimation

procedure FreeAndNil(var Obj);

var
  lyTitulo : TLayout;
  FlblTitulo : TLabel;
  FDivisor : TRectangle;
  FlblNomeItem : TLabel;
  FAnimacao : TFloatAnimation;
  FHabilitado: Boolean;
 // FVertScrollBox : TVertScrollBox; //Em Teste...

type
  TFundo = class(TRectangle);
  TMenuMob = class(TLayout);

  TAnimacaoF = class(TFloatAnimation)
    public
      { public declarations }
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

  TLinhaDiv = class(TRectangle)
  private
    FCorDivisor: TAlphaColor;
    FLarguraDivisor: Single;
    FCorBorda: TAlphaColor;
    procedure SetCorBorda(const Value: TAlphaColor);
    procedure SetCorDivisor(const Value: TAlphaColor);
    procedure SetLarguraDivisor(const Value: Single);
    public
      { public declarations }
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    published
      property CorDivisor: TAlphaColor read FCorDivisor write SetCorDivisor default $FF1E90FF;
      property CorBorda: TAlphaColor read FCorBorda write SetCorBorda default $00000000;
      property LarguraDivisor: Single read FLarguraDivisor write SetLarguraDivisor;
  end;

  TTitulo = class(TLabel)
  private
    FTitulo: String;
    procedure SetTitulo(const Value: String);
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Titulo: String read FTitulo write SetTitulo;
  end;

  TItemLabel = class(TLabel)
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TItem = class(TFundo)
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TMenuOpcoes = class(TFundo)
  private
    FTitulo: String;
    FItem : TItem;
    FCorDivisor: TAlphaColor;
    FLarguraDivisor: Single;
    FAoFechar: TNotifyEvent;
    FItems: TStrings;
    FAoDestruir: TNotifyEvent;
    FCorBorda: TAlphaColor;
    procedure SetTitulo(const Value: String);
    procedure SetCorDivisor(const Value: TAlphaColor);
    procedure SetLarguraDivisor(const Value: Single);
    procedure SetAoFechar(const Value: TNotifyEvent);
    procedure SetItems(const Value: TStrings);
    function GetItems: TStrings;
    procedure SetAoDestruir(const Value: TNotifyEvent);
    procedure SetCorBorda(const Value: TAlphaColor);
    procedure DoPaint; override;
    { private declarations }
  protected
    { protected declarations }
    property AoFechar: TNotifyEvent read FAoFechar write SetAoFechar;
    property AoDestruir: TNotifyEvent read FAoDestruir write SetAoDestruir;
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  { published declarations }
    property Titulo: String read FTitulo write SetTitulo;
//    property CorDivisor: TAlphaColor read FCorDivisor write SetCorDivisor default $FF1E90FF;
//    property CorBorda: TAlphaColor read FCorBorda write SetCorBorda default $00000000;
//    property LarguraDivisor: Single read FLarguraDivisor write SetLarguraDivisor;
    property Items: TStrings read GetItems write SetItems;
  end;


Type
  TFundoMenu = class(TFundo)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { published declarations }

end;

type
  TPopupMenuMob = class(TMenuMob)
  private
    FLargura: Single;
    FItems: TStrings;
    FTitulo: String;
    FDivisorMenu: TRectangle;
    FAoExibir: TNotifyEvent;
    FAoClicar: TNotifyEvent;
    function GetLargura: Single;
    procedure SetItens(const Value: TStrings);
    procedure SetDivisorMenu(const Value: TRectangle);
    procedure SetAoClicar(const Value: TNotifyEvent);
    procedure SetAoExibir(const Value: TNotifyEvent);
    property AoClicar: TNotifyEvent read FAoClicar write SetAoClicar;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AoExibir: TNotifyEvent read FAoExibir write SetAoExibir;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents(NomePaleta, [TPopupMenuMob]);
end;

procedure FreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;

{ TPopupMenuMob }
procedure TPopupMenuMob.SetAoClicar(const Value: TNotifyEvent);
begin
  FAoClicar := Value;
  SetFocus;
end;

procedure TPopupMenuMob.SetAoExibir(const Value: TNotifyEvent);
begin
  FAoExibir := Value;
end;

constructor TPopupMenuMob.Create(AOwner: TComponent);
Var
  rcOpcoes : TMenuOpcoes;
  rcFundo : TFundoMenu;
begin
  inherited;

  Position.X := lyMenu_Opcoes_PosicaoX;
  Position.Y := lyMenu_Opcoes_PosicaoY;
  Margins.Left := lyMenu_Opcoes_Margem_Esquerda;
  Margins.Right := lyMenu_Opcoes_Margem_Direita;
  Align := TAlignLayout.Client;
  Visible := True;

  rcFundo := TFundoMenu.Create(Self);
  rcFundo.Parent := Self;
  rcFundo.OnClick := AoClicar;

  rcOpcoes := TMenuOpcoes.Create(nil);
  rcOpcoes.Width := Menu_Opcoes_Largura;  // Exemplo de Edição...
  rcOpcoes.Height := Menu_Opcoes_Altura; // Exemplo de Edição...
  rcOpcoes.Name := Menu_Opcoes_Comp_Nome+IntToStr(rcOpcoes.ComponentCount); //Esse 1 é para compensar os TRectangle que já forma criados
  rcOpcoes.Parent := Self;
  rcOpcoes.BringToFront;
  rcOpcoes.Titulo := Menu_Opcoes_Titulo;
  rcOpcoes.CorDivisor := Menu_Opcoes_Cor_Divisor;
  rcOpcoes.LarguraDivisor := Menu_Opcoes_Largura_Divisor;

end;

destructor TPopupMenuMob.Destroy;
begin
  inherited;
end;

function TPopupMenuMob.GetLargura: Single;
begin
  FLargura := Self.Width;
  result := FLargura;
end;

procedure TPopupMenuMob.SetDivisorMenu(const Value: TRectangle);
begin
  FDivisorMenu := Value;
end;

procedure TPopupMenuMob.SetItens(const Value: TStrings);
begin
  FItems := Value;
end;

{ TMenuOpcoes }

constructor TMenuOpcoes.Create(AOwner: TComponent);
var
  I: Integer;

begin

  inherited;
  //Teste...
//  FVertScrollBox := TVertScrollBox.Create(Self);
//  FVertScrollBox.Align := TAlignLayout.Client;

  // Padrão para criação do menu das Opções
 Align := TAlignLayout.Center;
 Fill.Color := Opcoes_Cor_Fundo; // $FFFFFF = White; FF = 255 Alpha
 Stroke.Color := Opcoes_Cor_Borda; // Borda Null
// Parent := Self;//FVertScrollBox; //
 XRadius := XRadius_Padrao;
 YRadius := YRadius_Padrao;
 Width := Opcoes_Width;
 Height := Opcoes_Height;


  // Lista de Itens do Menu
  FItems := TStringList.Create;
 // TStringList(FItems).OnChange := DoItemsChanged;

  //Layout de Fundo
  lyTitulo := TLayout.Create(nil);
  lyTitulo.Height := lyTitulo_Altura;
  lyTitulo.Align := TAlignLayout.MostTop;
  lyTitulo.Parent := Self;

  //Linha de Divisão do Menu
  FDivisor := TLinhaDiv.Create(nil);
  FDivisor.Parent := lyTitulo;
//  FDivisor.Height := FLarguraDivisor;
//  FDivisor.Fill.Color := FCorDivisor; // Dodgerblue;
//  FDivisor.Stroke.Color := FCorBorda; // Null
//  FDivisor.Align := TAlignLayout.Bottom;
//  FDivisor.Name := Divisor_Comp_Nome+IntToStr(FlblTitulo.ComponentCount);


  //Label do Titulo...
  FlblTitulo := TTitulo.Create(nil); //O Nil Permite que possamos editar no Modo Design
  FlblTitulo.Text := FTitulo;
  FlblTitulo.Name := lbTitulo_Comp_nome+IntToStr(FlblTitulo.ComponentCount);
  FlblTitulo.Parent := lyTitulo;


  //Animação que será usada nos Objetos...
  FAnimacao := TAnimacaoF.Create(Nil);
  FAnimacao.Parent := Self;
  FAnimacao.OnFinish := AoFechar;
//  FAnimacao.AnimationType := TAnimationType.&In;
//  FAnimacao.Delay := Animacao_Dalay;
//  FAnimacao.Duration := Animacao_Duracao;
//  FAnimacao.Interpolation := TInterpolationType.Quadratic;
//  FAnimacao.PropertyName := Animacao_Pro_Nome;
//  FAnimacao.StartValue := Animacao_Valor_Inicio;
//  FAnimacao.StopValue := Animacao_Valor_Final;
//  FAnimacao.Name := Animacao_Comp_Nome+IntToStr(FAnimacao.ComponentCount);

end;

destructor TMenuOpcoes.Destroy;
var
  I: Integer;
begin
{
Está dando Erro ao Destruir os Objetos...
}
//  for I := FItems.Count  downto 0 do
//  Begin
//    FreeAndNil(FItem.Components[I].Owner);
//    FreeAndNil(FlblNomeItem.Components[I].Owner);
//  End;
//
//  lyTitulo.Free;
//  FlblTitulo.Free;
//  FDivisor.Free;
//  FreeAndNil(FItem);
//  FlblNomeItem.Free;
//  FAnimacao.Free;
//
//  FItems.Free;
  inherited;
end;

procedure TMenuOpcoes.DoPaint;
begin
  inherited;
  Anchors := [TAnchorKind.akLeft,TAnchorKind.akRight,TAnchorKind.akTop];
end;

function TMenuOpcoes.GetItems: TStrings;
begin
 Result := FItems;
end;

procedure TMenuOpcoes.SetAoDestruir(const Value: TNotifyEvent);
begin
  FAoDestruir := Value;
end;

procedure TMenuOpcoes.SetAoFechar(const Value: TNotifyEvent);
begin
  FAoFechar := Value;
  FAnimacao.Enabled := False;
end;

procedure TMenuOpcoes.SetCorBorda(const Value: TAlphaColor);
begin
  FCorBorda := Value;
  FDivisor.Stroke.Color := FCorBorda;
end;

procedure TMenuOpcoes.SetCorDivisor(const Value: TAlphaColor);
begin
  FCorDivisor := Value;
  FDivisor.Fill.Color := FCorDivisor;
end;

procedure TMenuOpcoes.SetItems(const Value: TStrings);
var
  I: Integer;

  procedure CriaItem;
  Begin
    FItem := TItem.Create(nil);
    FItem.Parent := Self;
    FItem.Name := Item_Comp_Nome + IntToStr(I+1);
  End;

  procedure CriaLabelItem;
  Begin
    FlblNomeItem := TItemLabel.Create(nil);
    FlblNomeItem.Text := Fitems.Strings[I];
    FlblNomeItem.Parent := FItem;
    FlblNomeItem.Name := lbItem_Comp_Nome + IntToStr(I+1);
  End;

begin

{
Este metodo recupera os itens gravados na variavel e atribui a lista porém
gera um bug ao inserir novos itens
FItems.Assign(Value);
}

  // uso este metodo para que a lista seja limpa a cada nova inserção
  FItems := Value;

  for I := FItems.Count -1 downto 0 do
  Begin
    CriaItem;

    CriaLabelItem;
  End;

end;

procedure TMenuOpcoes.SetLarguraDivisor(const Value: Single);
begin
  FLarguraDivisor := Value;
  FDivisor.Height := FLarguraDivisor;
end;

procedure TMenuOpcoes.SetTitulo(const Value: String);
begin
  FTitulo := Value;
  FlblTitulo.Text := FTitulo;
end;

{ TFundoMenu }

constructor TFundoMenu.Create(AOwner: TComponent);
begin
  inherited;
  Align := TAlignLayout.Client;
  Fill.Color := Fundo_Menu_Cor; // $000000 = Black; FF = 255 Alpha
  Stroke.Color := Fundo_Menu_Cor_Linha; // Null
  Opacity := Fundo_Menu_Opacidade;
end;

destructor TFundoMenu.Destroy;
begin
  //
  inherited;
end;

{ TItem }

constructor TItem.Create(AOwner: TComponent);
begin
  inherited;
  Height := Item_Altura;
  Fill.Color := Item_Cor_Fundo; //White
  Stroke.Color := Item_Cor_Linha; // Dodgerblue;
  Stroke.Thickness := Item_Largura_Linha; //Largura da borda do retangulo do item
  XRadius := Item_XRadius;
  YRadius := Item_YRadius;
  Align := TAlignLayout.MostTop;
end;

destructor TItem.Destroy;
begin
 //
  inherited;
end;

{ TItemLabel }

constructor TItemLabel.Create(AOwner: TComponent);
begin
  inherited;
  Align := TAlignLayout.Top;
  Height := lbItem_Altura;
  Margins.Left := lbItem_Margem_Esquerda;
  Margins.Right := lbItem_Margem_Direita;
  StyledSettings := [TStyledSetting.Family,TStyledSetting.FontColor, TStyledSetting.Style];
  TextSettings.HorzAlign := TTextAlign.Center;
  TextSettings.Font.Size := lbItem_Fonte_Tamanho;
end;

destructor TItemLabel.Destroy;
begin
  //
  inherited;
end;

{ TTitulo }

constructor TTitulo.Create(AOwner: TComponent);
begin
  inherited;
  Align := TAlignLayout.Client;
  Margins.Left := lbTitulo_Margin_Esquerda;
  Margins.Right := lbTitulo_Margin_Direita;
  TextSettings.Font.Size := lbTitulo_Fonte_Tamanho;
  TextSettings.Font.Style := [TFontStyle.fsBold];
  TextSettings.Trimming := TTextTrimming.None;
  StyledSettings := [TStyledSetting.Family,TStyledSetting.FontColor];
end;

destructor TTitulo.Destroy;
begin
  //
  inherited;
end;

procedure TTitulo.SetCorBorda(const Value: TAlphaColor);
begin
  FCorBorda := Value;
end;

procedure TTitulo.SetCorDivisor(const Value: TAlphaColor);
begin
  FCorDivisor := Value;
end;

procedure TTitulo.SetLarguraDivisor(const Value: Single);
begin
  FLarguraDivisor := Value;
end;

procedure TTitulo.SetTitulo(const Value: String);
begin
  FTitulo := Value;
end;

{ TAnimacaoF }

constructor TAnimacaoF.Create(AOwner: TComponent);
begin
  inherited;
  //Animação que será usada nos Objetos...
  AnimationType := TAnimationType.&In;
  Delay := Animacao_Dalay;
  Duration := Animacao_Duracao;
  Interpolation := TInterpolationType.Quadratic;
  PropertyName := Animacao_Pro_Nome;
  StartValue := Animacao_Valor_Inicio;
  StopValue := Animacao_Valor_Final;
  Name := Animacao_Comp_Nome+IntToStr(ComponentCount);
end;

destructor TAnimacaoF.Destroy;
begin
  //
  inherited;
end;

{ TLinhaDiv }

constructor TLinhaDiv.Create(AOwner: TComponent);
begin
  inherited;
  //Linha de Divisão do Menu
  Height := FLarguraDivisor;
  Fill.Color := FCorDivisor; // Dodgerblue;
  Stroke.Color := FCorBorda; // Null
  Align := TAlignLayout.Bottom;
  Name := Divisor_Comp_Nome+IntToStr(ComponentCount);
end;

destructor TLinhaDiv.Destroy;
begin

  inherited;
end;

procedure TLinhaDiv.SetCorBorda(const Value: TAlphaColor);
begin
  FCorBorda := Value;
end;

procedure TLinhaDiv.SetCorDivisor(const Value: TAlphaColor);
begin
  FCorDivisor := Value;
end;

procedure TLinhaDiv.SetLarguraDivisor(const Value: Single);
begin
  FLarguraDivisor := Value;
end;

end.
