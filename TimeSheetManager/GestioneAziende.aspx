<%@ Page Title="" Language="C#" MasterPageFile="~/TimeSheetMasterPage.Master" AutoEventWireup="true" CodeBehind="GestioneAziende.aspx.cs" Inherits="TimeSheetManager.GestioneAziende" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/StiliAziende.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="Contenitore">
        <div id="ParametriRicerca">
            <table>
                <tr style="height: 40px;">
                    <td style="width:150px;">Codice</td>
                    <td>
                        <asp:TextBox ID="TxtCodice" runat="server" CssClass="Testo" Width="400"></asp:TextBox>
                    </td>
                </tr>
                <tr style="height: 40px;">
                    <td style="width:150px;">Descrizione</td>
                    <td>
                        <asp:TextBox ID="TxtDescrizione" runat="server" CssClass="Testo" Width="400"></asp:TextBox>
                    </td>
                </tr>
                <tr style="height: 40px;">
                    <td style="width:150px;">Indirizzo</td>
                    <td>
                        <asp:TextBox ID="TxtIndirizzo" runat="server" CssClass="Testo" Width="400"></asp:TextBox>
                    </td>
                </tr>
                <tr style="height: 40px;">
                    <td style="width:150px;">Mail</td>
                    <td>
                        <asp:TextBox ID="TxtMail" runat="server" CssClass="Testo" Width="400"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="BtnCerca" runat="server" Text="Cerca" CssClass="BottoneCerca" 
                            onclick="BtnCerca_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <div id="TastiNuovoPulisci">
            <asp:Button ID="BtnNuovaRisorsa" runat="server" Text="Nuova Risorsa" 
                CssClass="BottoneNuovo" onclick="BtnNuovaRisorsa_Click" />
            <asp:Button ID="BtnPulisci" runat="server" Text="Pulisci Maschera" 
                CssClass="BottonePulisci" onclick="BtnPulisci_Click" />
        </div>
        <div id="RisultatiRicerca">
            <asp:GridView ID="GrdRisultatiRicerca" runat="server"
                AutoGenerateColumns="False" BorderColor="#0033CC" BorderStyle="Solid" 
                BorderWidth="1px" HorizontalAlign="Left" Width="98%" 
                DataKeyNames="Codice" onrowcommand="GrdRisultatiRicerca_RowCommand">
                <AlternatingRowStyle BackColor="#9FDBFF" />
                <Columns>
                    <asp:BoundField DataField="Codice" HeaderText="Codice" ReadOnly="True" 
                        SortExpression="Codice" />
                    <asp:BoundField DataField="Descrizione" HeaderText="Nominativo" 
                        SortExpression="Descrizione" />
                    <asp:BoundField DataField="Indirizzo" HeaderText="Account" 
                        SortExpression="Indirizzo" />
                    <asp:BoundField DataField="Mail" HeaderText="CostoGiornaliero" 
                        SortExpression="Mail" />
                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                        <ItemTemplate>
                            <asp:Button ID="BtnModificaRisorsa" runat="server" Text="Modifica" 
                                CssClass="BottoneModificaInGriglia" CommandName="Modifica" 
                                CommandArgument='<%# DataBinder.Eval(Container, "RowIndex") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                        <ItemTemplate>
                            <asp:Button ID="BtnEliminaRisorsa" runat="server" Text="Elimina" 
                                CssClass="BottoneEliminanInGriglia" CommandName="Elimina" 
                                CommandArgument='<%# DataBinder.Eval(Container, "RowIndex") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle BackColor="#0033CC" BorderColor="#0033CC" BorderStyle="Solid" 
                    BorderWidth="2px" HorizontalAlign="Center" VerticalAlign="Middle" 
                    Font-Bold="True" ForeColor="White" />
            </asp:GridView>
        </div>
    </div>

    <!-- Inserisco un linkbutton solo x poter collegare il modalpopup dei messaggi -->
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
                    <asp:Button ID="BtnChiudi" runat="server" Text="Chiudi" CssClass="BottoneChiudi"/>
                    <asp:HiddenField ID="HiddenField1" runat="server" />
                </span>
            </div>
        </div>
    </asp:Panel>

    <!-- Inserisco un linkbutton solo x poter collegare il modalpopup dei messaggi -->
    <asp:HyperLink ID="HyperLink2" runat="server"></asp:HyperLink>
    <asp:ModalPopupExtender ID="Dati_ModalPopupExtender" runat="server" Enabled="True"
        TargetControlID="HyperLink2" PopupControlID="PnlRisorsa" BackgroundCssClass="ModalSfondo">
    </asp:ModalPopupExtender>
    <asp:Panel ID="PnlRisorsa" runat="server">
        <div class="ModalContenutoDatiRisorse">
            <div id="Div2" style="position: absolute; top: 0px; bottom: 0px; left: 0px; right: 0px;">
                <span class="Titolo">Nuova / Modifica Risorsa</span>
                <br />
                <br />
                <br />
                <br />
                <div style="height: 350px; overflow: auto;">
                    <table>
                        <tr style="height: 40px;">
                            <td style="width:150px;">Codice</td>
                            <td>
                                <asp:TextBox ID="TxtCodiceN" runat="server" CssClass="Testo" Width="400"></asp:TextBox>
                                <br />
                                <asp:RequiredFieldValidator ID="ReqCodice" runat="server" ErrorMessage="Il campo Codice è obbligatorio" 
                                    ValidationGroup="SalvaAzienda" ControlToValidate="TxtCodiceN" Display="Static" CssClass="CampiObbligatori"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr style="height: 40px;">
                            <td style="width:150px;">Descrizione</td>
                            <td>
                                <asp:TextBox ID="TxtDescrizioneN" runat="server" CssClass="Testo" Width="400"></asp:TextBox>
                            </td>
                        </tr>
                        <tr style="height: 40px;">
                            <td style="width:150px;">Indirizzo</td>
                            <td>
                                <asp:TextBox ID="TxtIndirizzoN" runat="server" CssClass="Testo" Width="400"></asp:TextBox>
                            </td>
                        </tr>
                        <tr style="height: 40px;">
                            <td style="width:150px;">Mail</td>
                            <td>
                                <asp:TextBox ID="TxtMailN" runat="server" CssClass="Testo" Width="400"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </div>
                <span style="position: absolute; bottom: 10px; left: 10px; right: 0px;">
                    <asp:Button ID="BtnSalva" runat="server" Text="Salva" 
                    CssClass="BottoneSalva" onclick="BtnSalva_Click" ValidationGroup="SalvaRisorsa" />
                    &nbsp;&nbsp;&nbsp;
                    <asp:Button ID="BtnChiudiDati" runat="server" Text="Chiudi" CssClass="BottoneChiudi"/>
                    <asp:HiddenField ID="HdnModalita" runat="server" />
                </span>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
