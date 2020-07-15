<%@ Page Title="" Language="C#" MasterPageFile="~/TimeSheetMasterPage.Master" AutoEventWireup="true" CodeBehind="GestioneConsolidamento.aspx.cs" Inherits="TimeSheetManager.GestioneConsolidamento" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/StiliConsolidamento.css" rel="Stylesheet" type="text/css" />
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
                            <asp:ListItem Selected="True">Mensile</asp:ListItem>
                            <asp:ListItem>Semestrale</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td>
                        <%-- Dati --%>
                        <table class="Parametri" style="width: 100%;">
                            <tr>
                                <td>Anno contratto
                                </td>
                                <td>
                                    <asp:DropDownList ID="DdlAnniContratto" runat="server" Width="100" CssClass="Testo"
                                        AutoPostBack="true" OnSelectedIndexChanged="DdlAnniContratto_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td>Contratto
                                </td>
                                <td>
                                    <asp:DropDownList ID="DdlContratti" runat="server" Width="300" CssClass="Testo"
                                        DataTextField="Descizione" DataValueField="Id" AutoPostBack="true"
                                        OnSelectedIndexChanged="DdlContratti_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:Label ID="LblPeriodoConsolidamento" runat="server" Text="Mese da consolidare"></asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="DdlMese" runat="server" Width="150" CssClass="Testo"
                                        DataTextField="mese" DataValueField="indice">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="DdlSemestre" runat="server" Width="100" CssClass="Testo" Visible="false">
                                        <asp:ListItem Value="1" Text="Primo"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Secondo"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>Stipulato da
                                </td>
                                <td>
                                    <asp:Label ID="LblStipulatoda" runat="server" Text="" Font-Bold="true"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Budget
                                </td>
                                <td>
                                    <asp:Label ID="LblBudget" runat="server" Text="" Font-Bold="true"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class="TastiCercaNuovoPulisci">
                        <asp:Button ID="BtnCerca" runat="server" Text="Cerca"
                            CssClass="BottoneCerca" OnClick="BtnCerca_Click" />
                        <asp:Button ID="BtnConsolida" runat="server" Text="Consolida"
                            CssClass="BottoneConsolida" OnClick="BtnConsolida_Click" />
                        <asp:Button ID="BtnPulisci" runat="server" Text="Pulisci"
                            CssClass="BottonePulisci" OnClick="BtnPulisci_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <div id="RisultatiRicerca">
            <%-- Griglia generata per consolidamento MENSILE --%>
            <asp:GridView ID="GrdRisultatiRicercaMese" runat="server"
                AutoGenerateColumns="False"
                BorderStyle="None"
                HorizontalAlign="Center"
                Width="98%"
                BackColor="White"
                CellPadding="4"
                ForeColor="Black"
                CssClass="GrdRisultatiRicerca" 
                OnRowDataBound="GrdConsolidamentoMese_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="Anno" HeaderText="Anno">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Mese" HeaderText="Mese">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Risorsa" HeaderText="Risorsa">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Nominativo" HeaderText="Nominativo">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FP" HeaderText="Figura professionale">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ErogatoTot" HeaderText="Erogato totale">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ErogatoInFattura" HeaderText="Erogato in fattura">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ErogatoInGaranzia" HeaderText="Erogato in garanzia">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                </Columns>
                <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                <HeaderStyle BackColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle"
                    Font-Bold="True" ForeColor="White" />
            </asp:GridView>
            <%-- Griglia generata per consolidamento SEMESTRALE --%>
            <asp:GridView ID="GrdRisultatiRicercaSemestre" runat="server"
                AutoGenerateColumns="False"
                BorderStyle="None"
                HorizontalAlign="Center"
                Width="98%"
                BackColor="White"
                CellPadding="4"
                ForeColor="Black"
                CssClass="GrdRisultatiRicerca">
                <Columns>
                    <asp:BoundField DataField="Anno" HeaderText="Anno">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Semestre" HeaderText="Semestre">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Aziende_FK" HeaderText="Azienda">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FiguraProfessionale" HeaderText="Figura Professionale">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Importo" HeaderText="Importo">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ErogatoTot" HeaderText="Erogato totale">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ErogatoInFattura" HeaderText="Erogato in fattura">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ErogatoInGaranzia" HeaderText="Erogato in garanzia">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                </Columns>
                <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                <HeaderStyle BackColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle"
                    Font-Bold="True" ForeColor="White" />
            </asp:GridView>
            <br />
            <asp:Panel ID="PnlConsolidamentoEsistente" runat="server">
                <div style="text-align: center; margin: 10px 0;">
                    <strong>Consolidamento precedentemente salvato nel sistema</strong>
                </div>
                <%-- Griglia generata per consolidamento MENSILE --%>
                <asp:GridView ID="GrdConsolidamentoEsistenteMese" runat="server"
                    AutoGenerateColumns="False"
                    BorderStyle="None"
                    HorizontalAlign="Center"
                    Width="98%"
                    BackColor="#e8f5e9"
                    CellPadding="4"
                    ForeColor="Black"
                    CssClass="GrdRisultatiRicerca" 
                    OnRowDataBound="GrdConsolidamentoMese_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="Anno" HeaderText="Anno">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Mese" HeaderText="Mese">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Risorse_FK" HeaderText="Risorsa">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Nominativo" HeaderText="Nominativo">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FigureProfessionali_FK" HeaderText="Figura professionale">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="ErogatoTot" HeaderText="Erogato totale">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="ErogatoInFattura" HeaderText="Erogato in fattura">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="ErogatoInGaranzia" HeaderText="Erogato in garanzia">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:BoundField>
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                    <HeaderStyle BackColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle"
                        Font-Bold="True" ForeColor="White" />
                </asp:GridView>
                <%-- Griglia generata per consolidamento SEMESTRALE --%>
                <asp:GridView ID="GrdConsolidamentoEsistenteSemestre" runat="server"
                AutoGenerateColumns="False"
                BorderStyle="None"
                HorizontalAlign="Center"
                Width="98%"
                BackColor="#e8f5e9"
                CellPadding="4"
                ForeColor="Black"
                CssClass="GrdRisultatiRicerca">
                <Columns>
                    <asp:BoundField DataField="Anno" HeaderText="Anno">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Semestre" HeaderText="Semestre">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Aziende_FK" HeaderText="Azienda">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FiguraProfessionale" HeaderText="Figura Professionale">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Importo" HeaderText="Importo">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ErogatoTot" HeaderText="Erogato totale">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ErogatoInFattura" HeaderText="Erogato in fattura">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ErogatoInGaranzia" HeaderText="Erogato in garanzia">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                </Columns>
                <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                <HeaderStyle BackColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle"
                    Font-Bold="True" ForeColor="White" />
            </asp:GridView>
            </asp:Panel>
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
                    <asp:Button ID="BtnChiudi" runat="server" Text="Chiudi" CssClass="BottoneChiudi" />
                    <asp:HiddenField ID="HiddenField1" runat="server" />
                </span>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
