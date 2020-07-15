<%@ Page Title="" Language="C#" MasterPageFile="~/TimeSheetMasterPage.Master" AutoEventWireup="true" CodeBehind="GestioneValidazione.aspx.cs" Inherits="TimeSheetManager.GestioneValidazione" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/StiliValidazione.css" rel="stylesheet" type="text/css" />
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
                            ID="RbtnTipo"
                            runat="server"
                            AutoPostBack="True"
                            RepeatDirection="Vertical"
                            OnSelectedIndexChanged="RbtnTipo_SelectedIndexChanged">
                            <asp:ListItem Value="Giorno" Text="Giorno" ></asp:ListItem>
                            <asp:ListItem Value="Mese" Text="Mese" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td>
                        <%-- Dati --%>
                        <asp:Panel ID="PnlGiorno" runat="server" ClientIDMode="Static">
                            <asp:Calendar
                                ID="CalendarValidazione"
                                runat="server"
                                ClientIDMode="Static"
                                FirstDayOfWeek="Monday"
                                ForeColor="#000000"
                                OnSelectionChanged="CalendarValidazione_SelectionChanged" >
                                <TitleStyle 
                                    BackColor="#ff6d00" />
                                <WeekendDayStyle 
                                    BackColor="#e65100" />
                                <DayHeaderStyle 
                                    Font-Underline="true"/>
                                <DayStyle Font-Underline="false" />
                                <SelectedDayStyle
                                    BackColor="#ffcc80"
                                    BorderColor="#ff6d00"
                                    BorderStyle="Solid" 
                                    BorderWidth="1px"
                                    ForeColor="#000000" 
                                    Font-Underline="true" />
                                <NextPrevStyle Font-Bold="true" />
                            </asp:Calendar>
                        </asp:Panel>
                        <asp:Panel ID="PnlMese" runat="server">
                            <table style="width: 100%;">
                                <tr>
                                    <td>Risorsa
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="DdlRisorsa" runat="server" Width="200" CssClass="Testo"
                                            DataTextField="Nominativo" DataValueField="Codice">
                                        </asp:DropDownList>
                                    </td>
                                    <td>Mese
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="DdlMese" runat="server" Width="200" CssClass="Testo">
                                            <asp:ListItem Text="Gennaio" Value="1" />
                                            <asp:ListItem Text="Febbraio" Value="2" />
                                            <asp:ListItem Text="Marzo" Value="3" />
                                            <asp:ListItem Text="Aprile" Value="4" />
                                            <asp:ListItem Text="Maggio" Value="5" />
                                            <asp:ListItem Text="Giugno" Value="6" />
                                            <asp:ListItem Text="Luglio" Value="7" />
                                            <asp:ListItem Text="Agosto" Value="8" />
                                            <asp:ListItem Text="Settembre" Value="9" />
                                            <asp:ListItem Text="Ottobre" Value="10" />
                                            <asp:ListItem Text="Novembre" Value="11" />
                                            <asp:ListItem Text="Dicembre" Value="12" />
                                        </asp:DropDownList>
                                    </td>
                                    <td>Anno
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="DdlAnno" runat="server" Width="200" CssClass="Testo" />
                                    </td>
                                    <td class="TastiCercaNuovoPulisci">
                                        <asp:Button ID="BtnCerca" runat="server" Text="Cerca" 
                                            CssClass="BottoneCerca" OnClick="BtnCerca_Click" />
                                        <asp:Button ID="BtnConferma" runat="server" Text="Conferma"
                                            CssClass="BottoneConsolida" OnClick="BtnConferma_Click" />
                                        <asp:Button ID="BtnPulisci" runat="server" Text="Pulisci"
                                            CssClass="BottonePulisci" OnClick="BtnPulisci_Click" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </div>
        <div id="RisultatiRicerca">
            <asp:Panel ID="PnlTotaleOreLavorate" runat="server" Visible="false" ClientIDMode="Static">
                Ore lavorate
                <asp:Label ID="LblOreLavorateTotali" runat="server" Text="-"></asp:Label>
                &nbsp;&nbsp;&nbsp;
                Giorni lavorati
                <asp:Label ID="LblGiorniLavoratiTotali" runat="server" Text="-"></asp:Label>
            </asp:Panel>

            <asp:GridView ID="GrdRisultatiRicerca" runat="server"
                AutoGenerateColumns="False"
                BorderStyle="None"
                HorizontalAlign="Center"
                Width="98%"
                BackColor="White"
                CellPadding="4"
                ForeColor="Black"
                CssClass="GrdRisultatiRicerca"
                OnRowDataBound="GrdRisultatiRicerca_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Data" HeaderText="Data" DataFormatString="{0:d}">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="DescrizioneRisorsa" HeaderText="Risorsa">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FigureProfessionali_FK" HeaderText="Figura">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Ingresso" HeaderText="Ingresso">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PausaPranzo" HeaderText="Pausa pranzo">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Rientro" HeaderText="Rientro">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Uscita" HeaderText="Uscita">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="OreLavorate" HeaderText="Ore Lavorate" DataFormatString="{0:F2}">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="LavoratoEffettivo" HeaderText="Lavorato Effettivo">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="DGS" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                        <ItemTemplate>
                            <asp:CheckBox 
                                ID="ChkValida" 
                                runat="server" 
                                Checked='<%# Convert.ToBoolean(Eval("Validato")) %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80px"></ItemStyle>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Arma" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                        <ItemTemplate>
                            <asp:CheckBox 
                                ID="ChkValidaArma" 
                                runat="server" 
                                Checked='<%# Convert.ToBoolean(Eval("ValidatoArma")) %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80px"></ItemStyle>
                    </asp:TemplateField>

                </Columns>
                <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                <HeaderStyle BackColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle"
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
                    <asp:Button ID="BtnChiudi" runat="server" Text="Chiudi" CssClass="BottoneChiudi" />
                    <asp:HiddenField ID="HiddenField1" runat="server" />
                </span>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
