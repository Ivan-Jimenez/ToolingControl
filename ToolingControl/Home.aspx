<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="ToolingControl.Control" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <section class="Control">
        <div class="hero"></div>
        <div class="wrap">
            <div class="container">
            <div class="content">
                <%-- Request TPM Header --%>
                <div class="header fondo-azul">
                    <h1>Mantenimiento</h1>
                </div>
                <div id="MaintTable" runat="server">
                    <h4>Solicitar TPM</h4>

                    

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

                <%-- Request Values --%>
                <div id="divPlanner" runat="server">
                    <input id="InputNP" disabled runat="server"/>
                    <%-- Planner --%>
                    <input id="InputPlanner" placeholder="Planner" runat="server" />
                    <div id="RequestReports" class="SW" runat="server" visible="false" >
                        <!-- Request FARO-->
                        <div id="FAROOption" runat="server" visible="false" class="row">
                            <div class="col-2">
                                 <label class="switch"><input type="checkbox" id="FAROCheckBox" runat="server"><span class="slider round"></span></label>
                            </div>
                            <div>
                                <div class="col-10"><label>FARO</label></div>
                            </div>
                        </div>
                        <%-- Request Validation report --%>
                        <div id="ValidationOption" runat="server" visible="false" class="row">
                            <div class="col-2">
                                 <label class="switch"><input type="checkbox" id="ValidationCheckBox" runat="server"><span class="slider round"></span></label>
                            </div>
                            <div>
                                <div class="col-10"><label>Validation</label></div>
                            </div>
                        </div>
                    </div>
                        
                    <%-- Comments --%>
                    <textarea id="TxtComment" runat="server" maxlength="150" placeholder="Comments..."></textarea>

                    <div class="btn-group">
                        <%--<asp:Button id="CancelRequestButton" onclick="Cancel_Click" runat="server" class="btn btn-danger"><i class="ion-md-arrow-round-back"></i></asp:Button>--%>
                        <asp:Button ID="CancelRequestButton" runat="server"  Text="Cancelar" CssClass="btn btn-danger" OnClick="Cancel_Click" />
                        <asp:Button ID="SendRequestButton" runat="server" Text="Enviar" CssClass="btn btn-success" OnClick="SendRequest_Click" />
                    </div>

                    <label id="ErrorLabel" runat="server"></label>

                </div>

                <div id="CurrentMaintSection" runat="server">
                    <h4>En Mantenimiento</h4>
                    <div class="fondo-tabla">
                    <%-- Starts MaintenanceLog Table --%>
                        <div>
                            <div style="overflow: hidden;"></div>
                            <div style="overflow: scroll; height: 350px;" onscroll="OnScrollDiv(this)">
                                <asp:GridView ID="CurrentMaintGrid" runat="server" DataKeyNames="NP" AutoGenerateColumns="False" 
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
                                        <asp:TemplateField HeaderText="MaintType">
                                            <ItemTemplate>
                                                <asp:Label ID="lblProgram" runat="server" Text='<%# Bind("MaintType") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFrequenc" runat="server" Text='<%# Bind("Status") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="FARO">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFrequencys" runat="server" Text='<%# Bind("FARO") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Validations">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFrequencgy" runat="server" Text='<%# Bind("Validation") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Request Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lblArea" runat="server" Text='<%# Bind("RequestDate") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Planning Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTotalNormals" runat="server" Text='<%# Bind("PlanningDate") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Production Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTotalNorma" runat="server" Text='<%# Bind("ProductionDate") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Quality Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTotalAnnuals" runat="server" Text='<%# Bind("QualityDate") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Request Comment">
                                            <ItemTemplate>
                                                <asp:Label ID="lblLasts" runat="server" Text='<%# Bind("RequestComment") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Planning Comment">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNext" runat="server" Text='<%# Bind("PlanningComment") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Production Comment">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNexts" runat="server" Text='<%# Bind("ProductionComment") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Quality Comment">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNex" runat="server" Text='<%# Bind("QualityComment") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemTemplate></ItemTemplate>
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
                            <div style="overflow: hidden">
                            </div>
                        </div>
                    <%-- Ends MaintenanceLog Table --%>
                    </div>
                </div>
            </div>
        </div>
        </div>
        
    </section>

</asp:Content>
