<%@ Page Title="" Language="C#" MasterPageFile="~/TimeSheetMasterPage.Master" AutoEventWireup="true" CodeBehind="GestioneTimeSheet.aspx.cs" Inherits="TimeSheetManager.GestioneTimeSheet" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/StiliTimeSheet.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="Contenitore">
        <div id="ParametriRicerca">
            <table style="width: 100%">
                <tr>
                    <td class="SceltaOperazione">
                        <%-- Modalità --%>
                        <asp:RadioButtonList
                            ClientIDMode="Static"
                            ID="RbtnOperazione"
                            runat="server"
                            AutoPostBack="True"
                            OnSelectedIndexChanged="RbtnOperazione_SelectedIndexChanged">
                            <asp:ListItem>Inserimento</asp:ListItem>
                            <asp:ListItem Selected="True">Ricerca</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td>
                        <%-- Dati --%>
                        <table class="Parametri" style="width: 100%;">
                            <tr>
                                <td>Data Da
                                </td>
                                <td style="width: 100px;">
                                    <asp:TextBox ID="TxtData" runat="server" Width="80" CssClass="Testo"></asp:TextBox>
                                    <asp:MaskedEditExtender ID="MaskedTxtDataDa" runat="server" TargetControlID="TxtData"
                                        Mask="99/99/9999" MessageValidatorTip="true" MaskType="Date" AcceptAMPM="True"
                                        ErrorTooltipEnabled="True">
                                    </asp:MaskedEditExtender>
                                    <asp:MaskedEditValidator ID="MaskedVDataDa" runat="server"
                                        ControlExtender="MaskedTxtDataDa" ControlToValidate="TxtData"
                                        IsValidEmpty="True" InvalidValueMessage="Formato non valido" Display="Dynamic" />
                                </td>
                                <td>Data A
                                </td>
                                <td style="width: 100px;">
                                    <asp:TextBox ID="TxtDataA" runat="server" Width="80" CssClass="Testo"></asp:TextBox>
                                    <asp:MaskedEditExtender ID="MaskedTxtDataA" runat="server" TargetControlID="TxtDataA"
                                        Mask="99/99/9999" MessageValidatorTip="true" MaskType="Date" AcceptAMPM="True"
                                        ErrorTooltipEnabled="True">
                                    </asp:MaskedEditExtender>
                                    <asp:MaskedEditValidator ID="MaskedVTxtDataA" runat="server"
                                        ControlExtender="MaskedTxtDataA" ControlToValidate="TxtDataA"
                                        IsValidEmpty="True" InvalidValueMessage="Formato non valido" Display="Dynamic" />
                                </td>
                                <td>Risorsa
                                </td>
                                <td style="width: 210px;">
                                    <asp:DropDownList ID="DdlRisorsa" runat="server" Width="200" CssClass="Testo"
                                        DataTextField="Nominativo" DataValueField="Codice"
                                        AutoPostBack="true" OnSelectedIndexChanged="DdlRisorsa_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td>Figura
                                </td>
                                <td style="width: 210px;">
                                    <asp:DropDownList ID="DdlFigura" runat="server" Width="280" CssClass="Testo"
                                        DataTextField="Descrizione" DataValueField="Codice">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>Ingresso
                                </td>
                                <td style="width: 100px;">
                                    <asp:TextBox ID="TxtIngresso" runat="server" Width="80" CssClass="Testo"></asp:TextBox>
                                    <asp:MaskedEditExtender ID="MaskedTxtIngresso" runat="server" TargetControlID="TxtIngresso"
                                        Mask="99:99" MessageValidatorTip="true" MaskType="Time" AcceptAMPM="True"
                                        ErrorTooltipEnabled="True">
                                    </asp:MaskedEditExtender>
                                    <asp:MaskedEditValidator ID="MaskedVTxtIngresso1" runat="server"
                                        ControlExtender="MaskedTxtIngresso" ControlToValidate="TxtIngresso"
                                        IsValidEmpty="True" InvalidValueMessage="Formato non valido" Display="Dynamic" />
                                </td>
                                <td>Pranzo
                                </td>
                                <td style="width: 100px;">
                                    <asp:TextBox ID="TxtPranzo" runat="server" Width="80" CssClass="Testo"></asp:TextBox>
                                    <asp:MaskedEditExtender ID="MaskedTxtPranzo" runat="server" TargetControlID="TxtPranzo"
                                        Mask="99:99" MessageValidatorTip="true" MaskType="Time" AcceptAMPM="True"
                                        ErrorTooltipEnabled="True">
                                    </asp:MaskedEditExtender>
                                    <asp:MaskedEditValidator ID="MaskedVTxtPranzo" runat="server"
                                        ControlExtender="MaskedTxtPranzo" ControlToValidate="TxtPranzo"
                                        IsValidEmpty="True" InvalidValueMessage="Formato non valido" Display="Dynamic" />
                                </td>
                                <td>Rientro
                                </td>
                                <td style="width: 100px;">
                                    <asp:TextBox ID="TxtRientro" runat="server" Width="80" CssClass="Testo"></asp:TextBox>
                                    <asp:MaskedEditExtender ID="MaskedTxtRientro" runat="server" TargetControlID="TxtRientro"
                                        Mask="99:99" MessageValidatorTip="true" MaskType="Time" AcceptAMPM="True"
                                        ErrorTooltipEnabled="True">
                                    </asp:MaskedEditExtender>
                                    <asp:MaskedEditValidator ID="MaskedVTxtRientro" runat="server"
                                        ControlExtender="MaskedTxtRientro" ControlToValidate="TxtRientro"
                                        IsValidEmpty="True" InvalidValueMessage="Formato non valido" Display="Dynamic" />
                                </td>
                                <td>Uscita
                                </td>
                                <td style="width: 100px;">
                                    <asp:TextBox ID="TxtUscita" runat="server" Width="80" CssClass="Testo"></asp:TextBox>
                                    <asp:MaskedEditExtender ID="MaskedTxtUscita" runat="server" TargetControlID="TxtUscita"
                                        Mask="99:99" MessageValidatorTip="true" MaskType="Time" AcceptAMPM="True"
                                        ErrorTooltipEnabled="True">
                                    </asp:MaskedEditExtender>
                                    <asp:MaskedEditValidator ID="MaskedVTxtUscita" runat="server"
                                        ControlExtender="MaskedTxtUscita" ControlToValidate="TxtUscita"
                                        IsValidEmpty="True" InvalidValueMessage="Formato non valido" Display="Dynamic" />
                                </td>
                            </tr>
                            <tr>
                                <td>Rendicontate
                                </td>
                                <td style="width: 100px;">
                                    <asp:TextBox ID="TxtOreRendicontate" runat="server" Width="80" CssClass="Testo"></asp:TextBox>
                                    <asp:MaskedEditExtender ID="MaskedTxtOreRendicontate" runat="server" TargetControlID="TxtOreRendicontate"
                                        Mask="99:99" MessageValidatorTip="true" MaskType="Time" AcceptAMPM="True"
                                        ErrorTooltipEnabled="True">
                                    </asp:MaskedEditExtender>
                                    <asp:MaskedEditValidator ID="MaskedVTxtOreRendicontate" runat="server"
                                        ControlExtender="MaskedTxtOreRendicontate" ControlToValidate="TxtOreRendicontate"
                                        IsValidEmpty="True" InvalidValueMessage="Formato non valido" Display="Dynamic" />
                                </td>
                                <td>Attività
                                </td>
                                <td colspan="4">
                                    <asp:TextBox ID="TxtAttivita" runat="server" Width="500" TextMode="MultiLine" Height="50"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:CheckBox 
                                        ID="ChkInGaranzia" 
                                        runat="server" 
                                        Text="In Garanzia" 
                                        Checked="false" />
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class="TastiCercaNuovoPulisci">
                        <asp:Button ID="BtnCerca" runat="server" Text="Cerca"
                            CssClass="BottoneCerca" OnClick="BtnCerca_Click" />
                        <asp:Button ID="BtnNuovaGiornata" runat="server" Text="Salva Giornata"
                            CssClass="BottoneNuovo" OnClick="BtnNuovaGiornata_Click" />
                        <asp:Button ID="BtnPulisci" runat="server" Text="Pulisci"
                            CssClass="BottonePulisci" OnClick="BtnPulisci_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <div id="RisultatiRicerca">
            <div id="TotaliOre">
                &nbsp;
                Ore rendicontate:&nbsp;
                <asp:Label ID="LblOreRendicontateTotali" runat="server" Text="-"></asp:Label>&nbsp;(hhh:mm)
                &nbsp;&nbsp;&nbsp;
                Ore lavorate
                <asp:Label ID="LblOreLavorateTotali" runat="server" Text="-"></asp:Label>&nbsp;(hhh:mm)
                &nbsp;&nbsp;&nbsp;
                Differenza
                <asp:Label ID="LblDifferenza" runat="server" Text="-"></asp:Label>&nbsp;(hhh:mm)
            </div>

            <asp:Panel ID="PnlRisultatiRicerca" runat="server">
                <asp:GridView
                    ID="GrdRisultatiRicerca"
                    runat="server"
                    AutoGenerateColumns="False"
                    BorderStyle="None"
                    HorizontalAlign="Center"
                    Width="98%"
                    OnRowCommand="GrdRisultatiRicerca_RowCommand"
                    OnRowDataBound="GrdRisultatiRicerca_RowDataBound"
                    BackColor="White"
                    CellPadding="4"
                    ForeColor="Black"
                    GridLines="Horizontal"
                    CssClass="GrdRisultatiRicerca">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="Id">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Data" HeaderText="Data" DataFormatString="{0:d}">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Risorse_FK" HeaderText="Risorsa">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FigureProfessionali_FK" HeaderText="Figura">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Orario di lavoro">
                            <ItemTemplate>
                                <table class="GridDatiSuRiga">
                                    <tr>
                                        <td style="height: 25px; padding-left: 5px;">Ingresso:</td>
                                        <td style="height: 25px;">
                                            <strong>
                                                <asp:Label ID="LblIngresso" runat="server" Text='<%# Bind("Ingresso") %>' /></strong>
                                        </td>
                                        <td style="height: 25px; padding-left: 20px;">Uscita:</td>
                                        <td style="height: 25px;">
                                            <strong>
                                                <asp:Label ID="LblUscita" runat="server" Text='<%# Bind("Uscita") %>' /></strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 25px; padding-left: 5px;">Pausa dalle:</td>
                                        <td style="height: 25px;">
                                            <strong>
                                                <asp:Label ID="LblPausaDalle" runat="server" Text='<%# Bind("PausaPranzo") %>' /></strong>
                                        </td>
                                        <td style="height: 25px; width: 50px; padding-left: 20px;">alle:
                                        </td>
                                        <td style="height: 25px;">
                                            <strong>
                                                <asp:Label ID="LblPausaAlle" runat="server" Text='<%# Bind("Rientro") %>' /></strong>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tasks (Numero - Titolo - Ore Lavorate)">
                            <ItemTemplate>
                                <div id="DivTasks" class="GridDatiSuRiga">
                                    <asp:Label ID="LblNessunTask" runat="server" Text="Nessun task presente" Visible="false" ForeColor="Red"></asp:Label>
                                    <asp:ListView
                                        ID="LViewTasksLavorati"
                                        runat="server"
                                        Visible="false"
                                        OnItemDataBound="LViewTasksLavorati_ItemDataBound">
                                        <LayoutTemplate>
                                            <table id="TblTasksLavorati" runat="server" style="border-collapse: collapse; width: 100%; text-align: center">
                                                <tr runat="server" id="itemPlaceholder" />
                                            </table>
                                        </LayoutTemplate>
                                        <ItemTemplate>
                                            <tr runat="server">
                                                <td style="border-right: 1px solid Darkgrey; width: 10%;">
                                                    <asp:Label ID="LblNumeroTask" runat="server" Text='<%# Eval("Numero") %>' />
                                                    &nbsp;
                                                </td>
                                                <td style="border-right: 1px solid Darkgrey">
                                                    <asp:Label ID="LblTitoloTask" runat="server" Text='<%# Eval("Titolo") %>' />
                                                </td>
                                                <td style="width: 10%;">
                                                    <asp:Label ID="LblLavoratoTask" runat="server" Text='<%# Eval("Lavorato") %>' />
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:ListView>
                                </div>
                                <div style="text-align: center;">
                                    <asp:Label 
                                        ID="LblGiornataInGaranzia" 
                                        runat="server" 
                                        ForeColor="DarkBlue" 
                                        Text="Giornata lavorata in garanzia" 
                                        CssClass="TestoDashedMedium"
                                        Font-Bold="true"
                                        Font-Size="Medium"
                                        Visible="false"></asp:Label>
                                </div>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                            <ItemTemplate>
                                <asp:Image ID="ImgSituazioneTasks" runat="server" ImageUrl="~/Immagini/outline_ok.png" Height="25" Width="25" />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80px"></ItemStyle>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Lavorato" HeaderText="Lavorato" Visible="False">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Lavorato">
                            <ItemTemplate>
                                <table class="GridDatiSuRiga">
                                    <tr>
                                        <td style="width: 30px; height: 15px; padding-left: 5px;">gg:
                                        </td>
                                        <td>
                                            <asp:Label ID="LblGG" runat="server" Text='<%# Bind("GG") %>' />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 30px; height: 15px; padding-left: 5px;">hh:
                                        </td>
                                        <td>
                                            <asp:Label ID="LblHH" runat="server" Text='<%# Bind("HH") %>' />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 30px; height: 15px; padding-left: 5px;">mm:
                                        </td>
                                        <td>
                                            <asp:Label ID="LblMM" runat="server" Text='<%# Bind("MM") %>' />
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Ore">
                            <ItemTemplate>
                                <table class="GridDatiSuRiga">
                                    <tr>
                                        <td style="padding-left: 5px;">Rendicontate:
                                        </td>
                                        <td>
                                            <strong>
                                                <asp:Label ID="LblOreRendicontate" runat="server" Text='<%# Bind("RendicontatoEffettivo") %>' /></strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 50px; padding-left: 5px;">Lavorate:
                                        </td>
                                        <td>
                                            <strong>
                                                <asp:Label ID="LblOreLavorate" runat="server" Text='<%# Bind("LavoratoEffettivo") %>' /></strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 5px;">Differenza:
                                        </td>
                                        <td>
                                            <strong>
                                                <asp:Label ID="LblDifferenzaLavorateConRendicontate" runat="server" Text='<%# Bind("DifferenzaLavoratoConRendicontato") %>' /></strong>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="LavoratoInMinuti" HeaderText="Lavorato in minuti"
                            Visible="False">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Validazione" HeaderText="Validazione"
                            Visible="False" />
                        <asp:TemplateField HeaderText="Validato">
                            <ItemTemplate>
                                <div align="center">
                                    <asp:Label ID="LblValidato" runat="server" Text='<%# Bind("Validato") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Image ID="imgValidato" runat="server" Height="25px" ImageAlign="Middle"
                                        ImageUrl="~/Immagini/blank.png" Width="25px" />
                                </div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="TxtValidato" runat="server" Text='<%# Bind("Validato") %>'></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Validato Arma">
                            <ItemTemplate>
                                <div align="center">
                                    <asp:Label ID="LblValidatoArma" runat="server" Text='<%# Bind("ValidatoArma") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Image ID="imgValidatoArma" runat="server" Height="25px" ImageAlign="Middle"
                                        ImageUrl="~/Immagini/blank.png" Width="25px" />
                                </div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="TxtValidatoArma" runat="server" Text='<%# Bind("ValidatoArma") %>'></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                            <ItemTemplate>
                                <asp:Button ID="BtnModificaTimeSheet" runat="server" Text="Modifica"
                                    CssClass="BottoneModificaInGriglia" CommandName="Modifica"
                                    CommandArgument='<%# DataBinder.Eval(Container, "RowIndex") %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80px"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                            <ItemTemplate>
                                <asp:Button ID="BtnEliminaTimeSheet" runat="server" Text="Elimina"
                                    CssClass="BottoneEliminaInGriglia" CommandName="Elimina"
                                    CommandArgument='<%# DataBinder.Eval(Container, "RowIndex") %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80px"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                            <ItemTemplate>
                                <asp:Button ID="BtnTasksTimeSheet" runat="server" Text="Tasks"
                                    CssClass="BottoneTasksInGriglia" CommandName="GestioneTasks"
                                    CommandArgument='<%# DataBinder.Eval(Container, "RowIndex") %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80px"></ItemStyle>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                    <HeaderStyle BackColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle"
                        Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#F7F7F7" />
                    <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
                    <SortedDescendingCellStyle BackColor="#E5E5E5" />
                    <SortedDescendingHeaderStyle BackColor="#242121" />
                </asp:GridView>
            </asp:Panel>
        </div>
    </div>

    <asp:HyperLink ID="HyperLink1" runat="server"></asp:HyperLink>
    <asp:ModalPopupExtender ID="Messaggio_ModalPopupExtender" runat="server" Enabled="True"
        TargetControlID="HyperLink1" PopupControlID="PnlMessaggio" BackgroundCssClass="ModalSfondo">
    </asp:ModalPopupExtender>
    <asp:Panel ID="PnlMessaggio" runat="server">
        <div class="ModalContenutoMessaggio">
            <div id="Div1" style="position: absolute; top: 0px; bottom: 0px; left: 0px; right: 0px;">
                <span class="Titolo">Esito Operazione</span>
                <br />
                <br />
                <br />
                <br />
                <div style="height: 200px; overflow: auto;">
                    <asp:Label ID="LblMessaggio" runat="server" Font-Size="Small" ForeColor="Red"></asp:Label>
                </div>
                <span style="position: absolute; bottom: 10px; left: 10px; right: 0px;">
                    <asp:Button ID="BtnChiudi" runat="server" Text="Chiudi" CssClass="BottoneChiudi" />
                    <asp:HiddenField ID="HiddenField1" runat="server" />
                </span>
            </div>
        </div>
    </asp:Panel>

    <asp:HyperLink ID="HlinkGestioneTask" runat="server"></asp:HyperLink>
    <asp:ModalPopupExtender ID="GestioneTask_ModalPopupExtender" runat="server" Enabled="True"
        TargetControlID="HlinkGestioneTask" PopupControlID="PnlGestioneTask" BackgroundCssClass="ModalSfondo">
    </asp:ModalPopupExtender>
    <asp:Panel ID="PnlGestioneTask" runat="server">
        <div class="ModalContenutoGestioneTask" >
            <asp:HiddenField ID="HdnIdTask" runat="server" Value="" />
            <div id="DivGestioneTask" style="position: absolute; top: 10px; bottom: 10px; left: 5px; right: 5px;">
                <table style="width: 100%; text-align: left;">
                    <tr style="height: 50px;">
                        <td>Ore lavorate totali
                        </td>
                        <td>
                            <asp:Label ID="LblOreLavorateGiornata" runat="server"
                                Text="00:00" Font-Bold="true" ForeColor="DarkBlue"></asp:Label>
                        </td>
                        <td>Ore utilizzabili</td>
                        <td>
                            <asp:Label ID="LblOreUtilizzabiliGiornata" runat="server"
                                Text="-" Font-Bold="true" ForeColor="DarkBlue"></asp:Label>
                        </td>
                    </tr>
                    <tr style="height: 50px;">
                        <td style="width: 20%">Progetti
                        </td>
                        <td style="width: 20%">
                            <asp:DropDownList ID="DdlProgetti" runat="server" Width="100" CssClass="Testo"
                                DataTextField="Nome"
                                DataValueField="Nome"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="DdlProgetti_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td>Tasks
                        </td>
                        <td style="width: 50%;">
                            <asp:DropDownList ID="DdlTask" runat="server" Width="500" CssClass="Testo"
                                DataTextField="ValoriConcatenati" DataValueField="Id">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="height: 50px;">
                        <td>Tempo di lavoro (hh:mm)
                        </td>
                        <td>
                            <asp:TextBox ID="TxtOreLavorateTask" runat="server" Width="80" CssClass="Testo"></asp:TextBox>
                            <asp:MaskedEditExtender ID="MaskedEditExtenderOreLavorateTask" runat="server" TargetControlID="TxtOreLavorateTask"
                                Mask="99:99" MessageValidatorTip="true" MaskType="Time" AcceptAMPM="True"
                                ErrorTooltipEnabled="True">
                            </asp:MaskedEditExtender>
                            <asp:MaskedEditValidator ID="MaskedEditValidatorOreLavorateTask" runat="server"
                                ControlExtender="MaskedEditExtenderOreLavorateTask" ControlToValidate="TxtOreLavorateTask"
                                IsValidEmpty="True" InvalidValueMessage="Formato non valido" Display="Dynamic" />
                        </td>
                        <td>Note
                        </td>
                        <td>
                            <asp:TextBox ID="TxtNotaTask" runat="server" Width="500" TextMode="MultiLine" Height="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="height: 70px;">
                        <td colspan="4" style="text-align: center;">
                            <asp:Button ID="BtnSalvaTask" runat="server" Text="Salva"
                                CssClass="BottoneNuovoThin" OnClick="BtnSalvaTask_Click" />
                            &nbsp;
                            &nbsp;
                            <asp:Button ID="BtnPulisciTask" runat="server" Text="Pulisci"
                                CssClass="BottonePulisciThin" OnClick="BtnPulisciTask_Click" />
                        </td>
                    </tr>
                </table>
                <div style="text-align: center; padding: 5px 0;">
                    <asp:Label ID="LblMessaggioGestioneTask" runat="server" Font-Size="Medium" ForeColor="Red"></asp:Label>
                </div>
                <div style="height: 280px; overflow: auto;">
                    <asp:GridView
                        ID="GrdTasksLavorati"
                        runat="server"
                        AutoGenerateColumns="False"
                        BorderStyle="None"
                        HorizontalAlign="Center"
                        Width="98%"
                        BackColor="White"
                        ForeColor="Black"
                        GridLines="Horizontal"
                        CssClass="GrdRisultatiRicerca"
                        OnRowDataBound="GrdTasksLavorati_RowDataBound"
                        OnRowCommand="GrdTasksLavorati_RowCommand" >
                        <Columns>
                            <asp:BoundField DataField="Numero" HeaderText="Numero">
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="NomeProgetto" HeaderText="Progetto">
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Titolo" HeaderText="Titolo">
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Lavorato" HeaderText="Lavorato">
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Note" HeaderText="Note">
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                                <ItemTemplate>
                                    <asp:Button ID="BtnModificaTask" runat="server" Text="Modifica"
                                        CssClass="BottoneModificaTasksInGriglia" CommandName="ModificaTask"
                                        CommandArgument='<%# Bind("Id") %>' />
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80px"></ItemStyle>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                                <ItemTemplate>
                                    <asp:Button ID="BtnEliminaTask" runat="server" Text="Elimina"
                                        CssClass="BottoneEliminaTasksInGriglia" CommandName="EliminaTask"
                                        CommandArgument='<%# Bind("Id") %>' />
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80px"></ItemStyle>
                            </asp:TemplateField>
                        </Columns>
                        <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                        <HeaderStyle BackColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle"
                            Font-Bold="True" ForeColor="White" />
                    </asp:GridView>
                </div>
                <div style="text-align: center; position: relative; top: 5px;">
                    <asp:Button ID="BtnChiudiGestioneTask" runat="server" Text="Chiudi"
                        OnClick="BtnChiudiGestioneTask_Click"
                        CssClass="BottoneChiudiThin" />
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
