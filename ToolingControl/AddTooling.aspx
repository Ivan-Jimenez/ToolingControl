<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AddTooling.aspx.cs" Inherits="ToolingControl.AddTooling" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <section class="Add">
        <div class="hero"></div>
        <div class="wrap">
            <div class="container">
                <div class="content">
                    <%--<div class="header fondo-azul">
                        <h1>Añadir Tooling</h1>
                    </div>--%>


                <div class="header fondo-azul">
                    <h1>Catalogo</h1>
                </div>
                <div id="MaintTable" runat="server">
                    <%--<h4>Request TPM</h4>--%>

                    <div class="row">
                        <div class="col-3">
                            <input id="InputSearchTooling" class="" runat="server" placeholder="Número de Parte" />
                        </div>
                        <div class="col-3">
                            <asp:Button ID="Button1" runat="server" Text="Buscar" CssClass="btn btn-info" OnClick="SearchTool_Click" />
                        </div>
                        <div class="col-3"></div>
                        <div class="col-3">
                            <asp:Button ID="ButtonSearch" runat="server" Text="Agregar" CssClass="btn btn-success" OnClick="AddTool_Click" />

                        </div>
                            
                      </div>
                    <div class="fondo-tabla">
                        
                    <%-- Starts Maintenance Table --%>
                        <div id="DivRoot">
                            <div style="overflow: hidden;" id="DivHeaderRow"></div>
                            <div style="overflow: scroll; height: 350px;" onscroll="OnScrollDiv(this)" id="DivMainContent">
                                <asp:GridView ID="RequestGrid" runat="server" DataKeyNames="NP" AutoGenerateColumns="False" 
                                    ForeColor="#333333" ShowFooter="True" Width="100%" CellPadding="4" GridLines="None" OnSelectedItemChanged="OnSelectedItemChanged" >
                                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="ToolingID">
                                            <ItemTemplate>
                                                <asp:Label ID="lblToolingID" runat="server" Text='<%# Bind("ToolingID") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="NP">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNP" runat="server" Text='<%# Bind("NP") %>'></asp:Label>
                                            </ItemTemplate> 
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Area">
                                            <ItemTemplate>
                                                <asp:Label ID="lblArea" runat="server" Text='<%# Bind("Area") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Program">
                                            <ItemTemplate>
                                                <asp:Label ID="lblProgram" runat="server" Text='<%# Bind("Program") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Frequency">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFrequency" runat="server" Text='<%# Bind("Frequency") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("Status") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total Normal Maint.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTotalNormal" runat="server" Text='<%# Bind("TotalNormal") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total Annual Maint.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTotalAnnual" runat="server" Text='<%# Bind("TotalAnnual") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Last Normal">
                                            <ItemTemplate>
                                                <asp:Label ID="lblLast" runat="server" Text='<%# Bind("LastNormal") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Last Annual">
                                            <ItemTemplate>
                                                <asp:Label ID="lblLst" runat="server" Text='<%# Bind("LastAnnual") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Next Maint.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNext" runat="server" Text='<%# Bind("NextNormal") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemTemplate></ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <EditRowStyle BackColor="#999999" />
                                    <FooterStyle />
                                    <HeaderStyle CssClass="t-tabla fondo-azul"/>
                                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" HorizontalAlign="Center" />
                                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                                    <SortedDescendingCellStyle BackColor="#FFFDF8" />
                                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                                </asp:GridView>
                            </div>
                            <div id="DivFooterRow" style="overflow: hidden">
                            </div>
                        </div>
                    <%-- Ends Maintenance Table --%>
                    </div>
                </div>




                    <div id="Add_tooling" visible="false" runat="server">
                        <h4>Datos del Tooling</h4>
                       
                            <div class="from-label-grupo">
                                <input name="ToolingID" runat="server" type="text" id="ToolingIDInput" autocomplete="off" min="0" placeholder="ToolingID"/>
                            </div>
                            <div class="from-label-grupo">
                                <input name="NP" runat="server" type="text" id="NPInput" autocomplete="off" min="0" placeholder="PN"/>
                            </div>
                            
                            <select id="AreaSelect" runat="server">
                                <option value="0">Selecciona Area</option>
                                <option value="Decore">Decore</option>
                                <option value="LayUp">layUp</option>
                                <option value="CNC">CNC</option>
                            </select>
                            <select id="ProgramSelect" runat="server">
                                <option value="0">Selecciona programa</option>
                                <option value="787">787</option>
                                <option value="777">777</option>
                                <option value="Rancho">Rancho</option>
                            </select>
                            <select id="FrequencySelect" runat="server">
                                <option value="0">Frequencia de Mante.</option>
                                <option value="2 WEEKS">2 Semanas</option>
                                <option value="3 WEEKS">3 Semanas</option>
                                <option value="1 MONTH">1 Mes</option>
                                <option value="3 MONTHS">2 Meses</option>
                                <option value="6 MONTHS">6 Meses</option>
                            </select>

                        
                            <asp:Button ID="AddButton" runat="server" Text="Agregar" CssClass="btn btn-success" OnClick="AddTooling_Click" />
                             
                       
                    </div>
                     <label id="errorPlanner" style="color:#c10000; text-align: center;"  runat="server"></label>
                </div>
            </div>
        </div>
    </section>

</asp:Content>


