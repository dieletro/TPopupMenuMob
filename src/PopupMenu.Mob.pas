{ *******************************************************************************
  * Embardacero Delphi Visual Component                                          *
  * PopUpMenuMob for Mobile devices                                              *
  ********************************************************************************
  * Componente Criado Por Ruan Diego Lacerda Menezes & Douglas Colombo           *
  * Copyright (C) 2018                                                           *
  ******************************************************************************* }

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
  System.SysUtils, // FreeAndNill...
  FMX.Ani, // serve para o TFloatAnimation
  FMX.ActnList, // ICaption..
  PopupMenu.Constantes; // Constantes do Projeto

procedure FreeAndNil(var Obj);

type
  TFundo = class(TRectangle)
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TMenuMob = class(TLayout);
  TMenuMobLabel = class(TLabel);
  TAnimacaoFlutuante = class(TFloatAnimation);
  TMenuMobScroll = class(TVertScrollBox);

var
  lyTitulo: TLayout;
  FlblTitulo: TLabel;
  FDivisor: TRectangle;
  FAnimacao: TAnimacaoFlutuante;
  FHabilitado: Boolean;

type
  TAnimacaoF = class(TAnimacaoFlutuante)
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  // Classe em Teste....
  TMobScroll = class(TMenuMobScroll)
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FMenuMobScroll: TMobScroll; // Em Teste...

type
  TTituloLayout = class(TLayout)
  private
    procedure DoPaint; override;
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TLinhaDiv = class(TFundo)
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
    property CorDivisor: TAlphaColor read FCorDivisor write SetCorDivisor
      default $FF1E90FF;
    property CorBorda: TAlphaColor read FCorBorda write SetCorBorda
      default $00000000;
    property LarguraDivisor: Single read FLarguraDivisor
      write SetLarguraDivisor;
  end;

  TTitulo = class(TLabel)
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

  TItemLabel = class(TLabel, ICaption)
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  // Var
  // FlblNomeItem: TItemLabel;

type
  TItem = class(TFundo)
  private
    procedure DoPaint; override;
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TMenuOpcoes = class(TFundo)
  private
    FItem: TItem;
    FstrTemp: TStrings; // Armasena os Itens inseridos...
    FItems: TStrings;
    FlblNomeItem: TItemLabel;
    procedure SetItems(const Value: TStrings);
    function GetItems: TStrings;

    procedure DoPaint; override;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { published declarations }
    property Items: TStrings read GetItems write SetItems;
  end;

Var
  FFundo: TFundo;

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
    FItems: TStrings;
    FAoExibir: TNotifyEvent;
    FAoClicar: TNotifyEvent;
    rcOpcoes: TMenuOpcoes;
    rcFundo: TFundoMenu;
    MobScroll: TMobScroll;
    procedure SetItens(const Value: TStrings);
    procedure SetAoClicar(const Value: TNotifyEvent);
    procedure SetAoExibir(const Value: TNotifyEvent);
    property AoClicar: TNotifyEvent read FAoClicar write SetAoClicar;
    procedure Paint; override;
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
begin
  inherited;
  // Layout Principal
  Position.X := lyMenu_Opcoes_PosicaoX;
  Position.Y := lyMenu_Opcoes_PosicaoY;
  Margins.Left := lyMenu_Opcoes_Margem_Esquerda;
  Margins.Right := lyMenu_Opcoes_Margem_Direita;
  Align := TAlignLayout.Contents;
  Visible := True;
  Name := lyMenu_Opcoes_Comp_Nome + IntToStr(ComponentCount + 1);

  // Fundo com transparencia
  rcFundo := TFundoMenu.Create(Self);
  rcFundo.Parent := Self;
  rcFundo.OnClick := AoClicar;

  // Menu de Opções
  rcOpcoes := TMenuOpcoes.Create(nil);
  rcOpcoes.Parent := Self;
  rcOpcoes.BringToFront;

  // //Controle de Scroll para os itens...
  // MobScroll := TMobScroll.Create(nil);
  // MobScroll.Align := TAlignLayout.Client;
  // MobScroll.Parent := rcOpcoes;
end;

destructor TPopupMenuMob.Destroy;
begin
  inherited;

  // if rcOpcoes <> nil then
  // rcOpcoes.Free;
  //
  // if rcFundo <> nil then
  // rcFundo.Free;
end;

procedure TPopupMenuMob.Paint;
begin
  inherited;
  BringToFront;
end;

procedure TPopupMenuMob.SetItens(const Value: TStrings);
begin
  FItems := Value;
end;

{ TMenuOpcoes }

constructor TMenuOpcoes.Create(AOwner: TComponent);
begin
  inherited;

  // Padrão para criação do menu das Opções
  Align := TAlignLayout.Center;
  XRadius := XRadius_Padrao;
  YRadius := YRadius_Padrao;
  Width := Menu_Opcoes_Largura;
  Height := Menu_Opcoes_Altura;

  // Fill.Color := Opcoes_Cor_Fundo; // $FFFFFF = White; FF = 255 Alpha
  // Stroke.Color := Opcoes_Cor_Borda; // Borda Null
  // // Parent := FMenuMobScroll;//FVertScrollBox; //
  // Name     := Menu_Opcoes_Comp_Nome+IntToStr(ComponentCount+1); // Somo 1 para sair do Zero

  // Controle de Scroll para os itens...
  // FMenuMobScroll := TMobScroll.Create(Self);
  // FMenuMobScroll.Align := TAlignLayout.Client;
  // FMenuMobScroll.Parent := Self;

  // Lista de Itens do Menu
  FItems := TStringList.Create;
  FstrTemp := TStringList.Create;
  // TStringList(FItems).OnChange := DoItemsChanged;

  // Layout de Fundo
  lyTitulo := TTituloLayout.Create(nil);
  lyTitulo.Parent := Self;

  // Linha de Divisão do Menu
  FDivisor := TLinhaDiv.Create(nil);
  FDivisor.Parent := lyTitulo;

  // Label do Titulo...
  FlblTitulo := TTitulo.Create(nil);
  // O Nil Permite que possamos editar no Modo Design
  FlblTitulo.Parent := lyTitulo;

  // Animação que será usada nos Objetos...
  FAnimacao := TAnimacaoF.Create(nil);
  FAnimacao.Parent := Self;

end;

destructor TMenuOpcoes.Destroy;
begin
  inherited;

  // if lyTitulo <> nil then
  // lyTitulo.Free;
  //
  // if FDivisor <> nil then
  // FDivisor.Free;
  //
  // if FlblTitulo <> nil then
  // FlblTitulo.Free;
  //
  // if FAnimacao <> nil then
  // FAnimacao.Free;
  //
  // if FItems <> nil then
  // FItems.Free;
  //
  // if FstrTemp <> nil then
  // FstrTemp.Free;

end;

procedure TMenuOpcoes.DoPaint;
begin
  inherited;
  Anchors := [TAnchorKind.akLeft, TAnchorKind.akRight, TAnchorKind.akTop];
end;

function TMenuOpcoes.GetItems: TStrings;
begin
  Result := FItems;
end;

procedure TMenuOpcoes.SetItems(const Value: TStrings);
var
  A: Integer;
  E: Integer;
  I: Integer;
  O: Integer;
  U: Integer;

  procedure CriarItem;
  Begin
    FItem := TItem.Create(nil);
    FItem.Parent := Self;

    FlblNomeItem := TItemLabel.Create(nil);
    FlblNomeItem.Text := FItems.Strings[I];
    FlblNomeItem.Parent := FItem;
    //Add o item novo a lista
    FstrTemp.Add(FItems.Strings[I]);
  End;

begin
  FItems.Assign(Value);
  { TODO 5 -oDiego -cItems : Não esta aceitando itens com o mesmo nome... }
  for I := FItems.Count - 1 downto 0 do
  Begin
    O := FstrTemp.IndexOf(FItems.Strings[I]);
    if (O = -1) then // Não Está na Lista...
    Begin
      CriarItem;
    End
      Else //O Item já está lista...
    Begin
      // Se a contagem dos itens da lista for maior que a lista temporaria, inserir...
      if ((FItems.Count - 1) > (FstrTemp.Count - 1)) then
        CriarItem
      Else
      //Se For menor Então Remova o respectivo Item
      if ((FItems.Count - 1) < (FstrTemp.Count - 1)) then
      Begin
        { TODO 5 -oDiego -cItems :
        Varrer os componentes TItem e TLabelItem para Excluir o
        Componente respectivo ao nome que não esta na Lista, caso
        ele realmente exista }
        for U := 0 to FstrTemp.Count - 1 do
        Begin
          O := FItems.IndexOf(FstrTemp.Strings[U]);
          if O = - 1 then
          Begin
            for E := 0 to FItem.ComponentCount -1 do
            Begin
              if FItem.Components[E].Name = FstrTemp.Strings[U] then
              Begin
                FItem.Components[E].Destroy;
                //Remover o Item da Lista FstrTemp aki...
                //with TLabel(FindComponent('novo label') do
                //    begin
                //      Free;
                //    end;
              End;
            End;
          End;
        End;
      End;

    End;
  end;
End;
{ TFundoMenu }

constructor TFundoMenu.Create(AOwner: TComponent);
begin
  inherited;
  Align := TAlignLayout.Client;
  Fill.Color := Fundo_Menu_Cor; // $000000 = Black; FF = 255 Alpha
  Stroke.Color := Fundo_Menu_Cor_Linha; // Null
  Opacity := Fundo_Menu_Opacidade;
  Name := 'MobFundo' + IntToStr(ComponentCount + 1);
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
  Fill.Color := Item_Cor_Fundo; // White
  Stroke.Color := Item_Cor_Linha; // Dodgerblue;
  Stroke.Thickness := Item_Largura_Linha;
  // Largura da borda do retangulo do item
  XRadius := Item_XRadius;
  YRadius := Item_YRadius;
  Align := TAlignLayout.Top;
  Name := Item_Comp_Nome + IntToStr(ComponentCount + 1);
  Margins.Left := 3;
  Margins.Right := 3;
  Margins.Top := 3;
end;

destructor TItem.Destroy;
begin
  //
  inherited;
end;

procedure TItem.DoPaint;
begin
  inherited;
  if (Width > 89) and (Width <= 127) then
    Height := 76;

  if (Width > 73) and (Width <= 89) then
    Height := 106;

  if (Width > 61) and (Width <= 73) then
    Height := 126;

  if (Width > 58) and (Width <= 61) then
    Height := 166;

  if Width <= 58 then
    Height := 186;

  if Width > 127 then
    Height := Item_Altura;
end;

{ TItemLabel }

constructor TItemLabel.Create(AOwner: TComponent);
begin
  inherited;
  Align := TAlignLayout.Top;
  Height := lbItem_Altura;
  Margins.Left := lbItem_Margem_Esquerda;
  Margins.Right := lbItem_Margem_Direita;
  StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor,
    TStyledSetting.Style];
  TextSettings.HorzAlign := TTextAlign.Center;
  TextSettings.Font.Size := lbItem_Fonte_Tamanho;
  Name := lbItem_Comp_Nome + IntToStr(ComponentCount + 1);
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
  Text := Menu_Opcoes_Titulo;
  Margins.Left := lbTitulo_Margin_Esquerda;
  Margins.Right := lbTitulo_Margin_Direita;
  TextSettings.Font.Size := lbTitulo_Fonte_Tamanho;
  TextSettings.Font.Style := [TFontStyle.fsBold];
  TextSettings.Trimming := TTextTrimming.None;
  StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
  Name := lbTitulo_Comp_nome + IntToStr(ComponentCount + 1);

end;

destructor TTitulo.Destroy;
begin
  //
  inherited;
end;

{ TAnimacaoF }

constructor TAnimacaoF.Create(AOwner: TComponent);
begin
  inherited;
  // Animação que será usada nos Objetos...
  AnimationType := TAnimationType.&In;
  Delay := Animacao_Dalay;
  Duration := Animacao_Duracao;
  Interpolation := TInterpolationType.Quadratic;
  PropertyName := Animacao_Pro_Nome;
  StartValue := Animacao_Valor_Inicio;
  StopValue := Animacao_Valor_Final;
  Name := Animacao_Comp_Nome + IntToStr(ComponentCount + 1);
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
  // Linha de Divisão do Menu
  Height := Divisor_Largura;
  Fill.Color := Divisor_Cor_Fundo; // Dodgerblue;
  Stroke.Color := Divisor_Cor_Borda; // Null
  Stroke.Thickness := Divisor_Largura_Linha;
  Align := TAlignLayout.Bottom;
  Name := Divisor_Comp_Nome + IntToStr(ComponentCount + 1);
end;

destructor TLinhaDiv.Destroy;
begin

  inherited;
end;

procedure TLinhaDiv.SetCorBorda(const Value: TAlphaColor);
begin
  FCorBorda := Value;
  Stroke.Color := FCorBorda;
end;

procedure TLinhaDiv.SetCorDivisor(const Value: TAlphaColor);
begin
  FCorDivisor := Value;
  Fill.Color := FCorDivisor;
end;

procedure TLinhaDiv.SetLarguraDivisor(const Value: Single);
begin
  FLarguraDivisor := Value;
  Height := FLarguraDivisor;
end;

{ TTituloLayout }

constructor TTituloLayout.Create(AOwner: TComponent);
begin
  inherited;
  // Layout de Fundo
  Height := lyTitulo_Altura;
  Align := TAlignLayout.MostTop;
  Name := lyTitulo_Comp_Nome + IntToStr(ComponentCount + 1);
  Margins.Left := 3;
  Margins.Right := 3;
  Margins.Top := 3;
end;

destructor TTituloLayout.Destroy;
begin

  inherited;
end;

procedure TTituloLayout.DoPaint;
begin
  inherited;

  if (Width > 89) and (Width <= 127) then
    Height := 76; // 76

  if (Width > 73) and (Width <= 89) then
    Height := 106;

  if (Width > 61) and (Width <= 73) then
    Height := 126;

  if (Width > 58) and (Width <= 61) then
    Height := 166;

  if Width <= 58 then
    Height := 186;

  if Width > 127 then
    Height := lyTitulo_Altura;
end;

{ TMobScroll }

constructor TMobScroll.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMobScroll.Destroy;
begin

  inherited;
end;

{ TFundo }

constructor TFundo.Create(AOwner: TComponent);
begin
  inherited;
  // Padrão para criação do menu das Opções
  Fill.Color := Opcoes_Cor_Fundo;
  Stroke.Color := Opcoes_Cor_Borda;
  Name := Menu_Opcoes_Comp_Nome + IntToStr(ComponentCount + 1);
  // Somo 1 para sair do Zero
end;

destructor TFundo.Destroy;
begin

  inherited;
end;

end.
