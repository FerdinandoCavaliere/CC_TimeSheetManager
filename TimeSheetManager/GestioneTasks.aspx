<%@ Page Title="" Language="C#" MasterPageFile="~/TimeSheetMasterPage.Master" AutoEventWireup="true" CodeBehind="GestioneTasks.aspx.cs" Inherits="TimeSheetManager.GestioneTasks" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.3500.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/StiliTasks.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="Contenitore">
        <asp:Panel ID="PnlPrincipale" runat="server">
            <div id="ParametriRicerca">
                <table style="width: 100%;" class="Parametri">
                    <tr>
                        <td>
                            <table style="width: 100%;">
                                <tr>
                                    <td class="Dati">
                                        <%-- Contratto, progetto, task --%>
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>Contratto
                                                </td>
                                                <td>
                                                    <asp:DropDownList
                                                        ID="DdlContratti"
                                                        runat="server"
                                                        Width="200"
                                                        CssClass="Testo"
                                                        DataTextField="ValoriConcatenati"
                                                        DataValueField="Id"
                                                        AutoPostBack="true"
                                                        OnSelectedIndexChanged="DdlContratti_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Data contratto
                                                </td>
                                                <td>
                                                    <asp:Label
                                                        ID="LblDataContratto"
                                                        runat="server"
                                                        Width="80" >
                                                    </asp:Label>
                                                </td>
                                                <td>Budget
                                                </td>
                                                <td>
                                                    <asp:Label
                                                        ID="LblBudget"
                                                        runat="server"
                                                        Width="80" >
                                                    </asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Progetto
                                                </td>
                                                <td>
                                                    <asp:DropDownList
                                                        ID="DdlProgetti" runat="server"
                                                        Width="130"
                                                        CssClass="Testo"
                                                        DataTextField="Nome"
                                                        DataValueField="Nome"
                                                        AutoPostBack="true"
                                                        OnSelectedIndexChanged="DdlProgetti_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Data richiesta
                                                </td>
                                                <td>
                                                    <asp:TextBox
                                                        ID="TxtDataRichiesta"
                                                        runat="server"
                                                        Width="80"
                                                        CssClass="Testo">
                                                    </asp:TextBox>
                                                    <asp:MaskedEditExtender
                                                        ID="MaskedTxtDataRichiesta"
                                                        runat="server"
                                                        TargetControlID="TxtDataRichiesta"
                                                        Mask="99/99/9999"
                                                        MessageValidatorTip="true"
                                                        MaskType="Date" AcceptAMPM="True"
                                                        ErrorTooltipEnabled="True">
                                                    </asp:MaskedEditExtender>
                                                    <asp:MaskedEditValidator
                                                        ID="MaskedETxtDataRichiesta"
                                                        runat="server"
                                                        ControlExtender="MaskedTxtDataRichiesta"
                                                        ControlToValidate="TxtDataRichiesta"
                                                        IsValidEmpty="True"
                                                        InvalidValueMessage="Formato non valido"
                                                        Display="Dynamic" />
                                                </td>
                                                <td colspan="2">
                                                    <asp:CheckBox ID="ChkInGaranzia" runat="server" CssClass="CheckboxNoBorder" Text="In garanzia" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Task Padre
                                                </td>
                                                <td style="text-align: left;">
                                                    <asp:DropDownList
                                                        ID="DdlTaskPadre"
                                                        runat="server"
                                                        Width="80"
                                                        CssClass="Testo"
                                                        DataTextField="NumeroTask"
                                                        DataValueField="Id">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Numero
                                                </td>
                                                <td style="text-align: left;">
                                                    <asp:TextBox
                                                        ID="TxtNumeroTask"
                                                        runat="server"
                                                        Width="80"
                                                        CssClass="Testo"></asp:TextBox>
                                                </td>
                                                <td>Totale giornate
                                                </td>
                                                <td>
                                                    <asp:TextBox
                                                        ID="TxtNumeroTotaleGiornate"
                                                        runat="server"
                                                        Width="40"
                                                        CssClass="Testo"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Titolo
                                                </td>
                                                <td colspan="5">
                                                    <asp:TextBox
                                                        ID="TxtTitolo"
                                                        runat="server"
                                                        Width="600"
                                                        CssClass="Testo"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Descrizione
                                                </td>
                                                <td colspan="5">
                                                    <asp:TextBox
                                                        ID="TxtDescrizione"
                                                        runat="server"
                                                        Width="600"
                                                        Rows="5"
                                                        TextMode="MultiLine" 
                                                        CssClass="Testo"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="FigureProfessionaliBorderLeft">
                                        <%-- Figure professionali --%>
                                        <h3 style="text-align: center;">Figure professionali</h3>
                                        <asp:ListView ID="ListViewGiorniPerFigura" runat="server">
                                            <LayoutTemplate>
                                                <table runat="server" id="TblGiorni" style="width: 100%; min-height: 160px;">
                                                    <tr runat="server" id="itemPlaceholder">
                                                    </tr>
                                                </table>
                                            </LayoutTemplate>
                                            <ItemTemplate>
                                                <tr id="Tr1" runat="server">
                                                    <td id="Td1" runat="server">Codice:
                                                    </td>
                                                    <td id="Td2" runat="server">
                                                        <asp:Label ID="LblCodiceFigura" runat="server" Width="50" Text='<%# Eval("Codice") %>' Font-Bold="true"></asp:Label>
                                                    </td>
                                                    <td id="Td3" runat="server">Descrizione:
                                                    </td>
                                                    <td id="Td4" runat="server">
                                                        <asp:Label ID="LblDescrizioneFigura" runat="server" Width="150" Text='<%# Eval("DescrizioneBreve") %>' Font-Bold="true"></asp:Label>
                                                    </td>
                                                    <td id="Td5" runat="server">Giorni:
                                                    </td>
                                                    <td id="Td6" runat="server">
                                                        <asp:TextBox ID="TxtGiorniRisorsa" runat="server" Width="50" Font-Bold="true"></asp:TextBox>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:ListView>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td class="TastiCercaNuovoPulisci">
                            <asp:Button ID="BtnCerca" runat="server" Text="Cerca"
                                CssClass="BottoneCerca" OnClick="BtnCerca_Click" />
                            <asp:Button ID="BtnNuovoTask" runat="server" Text="Salva Task"
                                CssClass="BottoneNuovo" OnClick="BtnNuovoTask_Click" />
                            <asp:Button ID="BtnPulisci" runat="server" Text="Pulisci"
                                CssClass="BottonePulisci" OnClick="BtnPulisci_Click" />
                        </td>
                    </tr>
                </table>
            </div>
            <div id="RisultatiRicerca">
                <asp:GridView ID="GrdRisultatiRicerca" runat="server"
                    AutoGenerateColumns="False"
                    BorderStyle="None"
                    HorizontalAlign="Center" 
                    Width="98%"
                    OnRowCommand="GrdRisultatiRicerca_RowCommand"
                    OnRowDataBound="GrdRisultatiRicerca_RowDataBound"
                    OnPreRender="GrdRisultatiRicerca_PreRender"
                    BackColor="White"
                    ForeColor="Black"
                    GridLines="Horizontal"
                    CssClass="GrdRisultatiRicerca">
                    <Columns>
                        <asp:BoundField DataField="NumeroTaskPadre" HeaderText="Padre">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField DataField="NumeroTask" HeaderText="Task">
                            <ItemStyle HorizontalAlign="Center" Font-Bold="True" VerticalAlign="Middle" Width="5%" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Titolo" HeaderText="Titolo" HeaderStyle-Width="500" ItemStyle-Wrap="False" HeaderStyle-Wrap="True">
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Wrap="true" Width="70%" />
                        </asp:BoundField>
                        <asp:BoundField DataField="DataRichiesta" HeaderText="Richiesta" DataFormatString="{0:d}">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="7%" />
                        </asp:BoundField>
                        <asp:BoundField DataField="PreventivoGGUU" HeaderText="gg">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="5%" Wrap="true" />
                        </asp:BoundField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" HeaderStyle-Width="20%"
                            HeaderText="Situazione giornate<br />Cod     |     Prev.     |     Spese     |     Rest.">
                            <ItemTemplate>
                                <asp:ListView ID="ListViewGiorniPerFiguraInGriglia" runat="server">
                                    <LayoutTemplate>
                                        <table runat="server" id="TblGiorni">
                                            <tr runat="server" id="itemPlaceholder">
                                            </tr>
                                        </table>
                                    </LayoutTemplate>
                                    <ItemTemplate>
                                        <tr id="Tr1" runat="server">
                                            <td id="Td1" runat="server" style="width: 50px; text-align: left;">
                                                <asp:Label ID="LblCodiceFigura" runat="server" Text='<%# Eval("FigureProfessionali_FK") %>'></asp:Label>
                                            </td>
                                            <td id="Td2" runat="server" style="width: 50px; text-align: right;">
                                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("PreventivoGGUU", "{0:00.00}") %>' ForeColor="Blue" Width="50"></asp:Label>
                                            </td>
                                            <td id="Td3" runat="server" style="width: 50px; text-align: right;">
                                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("giornateSpese", "{0:00.00}") %>' ForeColor="Green" Width="50"></asp:Label>
                                            </td>
                                            <td id="Td4" runat="server" style="width: 50px; text-align: right;">
                                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("giornateRestanti", "{0:00.00}") %>' ForeColor="Red" Width="50"></asp:Label>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:ListView>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                            <ItemTemplate>
                                <asp:Button ID="BtnModificaTask" runat="server" Text="Modifica"
                                    CssClass="BottoneModificaInGriglia" CommandName="Modifica"
                                    CommandArgument='<%# Eval("Id") %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="40px"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                            <ItemTemplate>
                                <asp:Button ID="BtnEliminaTask" runat="server" Text="Elimina"
                                    CssClass="BottoneEliminaInGriglia" CommandName="Elimina"
                                    CommandArgument='<%# Eval("Id") %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="40px"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                            <ItemTemplate>
                                <asp:Button ID="BtnTerminaTask" runat="server" Text="Termina"
                                    CssClass="BottoneTerminaInGriglia" CommandName="Termina"
                                    CommandArgument='<%# Eval("Id") %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="40px"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                            <ItemTemplate>
                                <asp:Button ID="BtnStampaTask" runat="server" Text="Stampa"
                                    CssClass="BottoneStampaInGriglia" CommandName="Stampa"
                                    CommandArgument='<%# Eval("Id") %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="40px"></ItemStyle>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                    <HeaderStyle BackColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle"
                        Font-Bold="True" ForeColor="White" />
                </asp:GridView>
            </div>
        </asp:Panel>

        <asp:Panel ID="PnlReport" runat="server">
            <CR:CrystalReportViewer ID="CrystalReportViewer2" runat="server"
                AutoDataBind="true"
                HasCrystalLogo="False"
                HasExportButton="True"
                HasPrintButton="True"
                HasToggleGroupTreeButton="False"
                HasToggleParameterPanelButton="False"
                ToolPanelView="None" />
        </asp:Panel>
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
