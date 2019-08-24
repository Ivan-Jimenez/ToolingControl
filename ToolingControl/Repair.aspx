<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Repair.aspx.cs" Inherits="ToolingControl.Repair" %>

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
                    <h1>Reparaciones</h1>
                </div>
                <div id="MaintTable" runat="server">
                    <%--<h4>Request TPM</h4>--%>

                    <div class="row">
                        <div class="col-3">
<%--                            <input id="InputSearchTooling" class="" runat="server" placeholder="ToolingID" />--%>
                        </div>
                        <div class="col-3">
<%--                            <asp:Button ID="Button1" runat="server" Text="Buscar" CssClass="btn btn-info" />--%>
                        </div>
                        <div class="col-3"></div>
                        <div class="col-3">
                            <asp:Button ID="ButtonSearch" runat="server" Text="Solicitar" CssClass="btn btn-info" OnClick="RequestRepair_Click"  />

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
                                        <asp:TemplateField HeaderText="Tipo Daño">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFrequency" runat="server" Text='<%# Bind("Damage") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Solicitado">
                                            <ItemTemplate>
                                                <asp:Label ID="Requested" runat="server" Text='<%# Bind("Requested") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Búsqueda">
                                            <ItemTemplate>
                                                <asp:Label ID="DamageSearch" runat="server" Text='<%# Bind("DamageSearch") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Reparación">
                                            <ItemTemplate>
                                                <asp:Label ID="Repair" runat="server" Text='<%# Bind("Repair") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Embolsado">
                                            <ItemTemplate>
                                                <asp:Label ID="Bagging" runat="server" Text='<%# Bind("Bagging") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Validación">
                                            <ItemTemplate>
                                                <asp:Label ID="staus" runat="server" Text='<%# Bind("RepairValidation") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                         <asp:TemplateField HeaderText="Solicito">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSolicito" runat="server" Text='<%# Bind("Requester") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                         <asp:TemplateField HeaderText="Reparador">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPlanner" runat="server" Text='<%# Bind("Repairman") %>'></asp:Label>
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
                            <div id="DivFooterRow" style="overflow: hidden">
                            </div>
                        </div>
                    <%-- Ends Maintenance Table --%>
                    </div>
                </div>

                    <div id="RequestRepair" visible="false" runat="server">
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
                            <select id="DamageSelect" runat="server">
                                <option value="0">Tipo de Daño</option>
                                <option value="PERFORATION">Perforacion</option>
                                <option value="HELICOIL">Helicoil</option>
                                <option value="FRACTURE">Fractura</option>
                                <option value="Buje mal estado">Buje mal estado</option>
                                <option value="BROCA">Broca Incrustada</option>
                                <option value="CAULPLATE DAMAGE">CaulPlate Dañado</option>
                            </select>

                            <div class="from-label-grupo">
                                <input name="Repairman" runat="server" type="text" id="RepairmanInput" autocomplete="off" min="0" placeholder="Reparador"/>
                            </div>
<%--                            <div class="from-label-grupo">
                                <input name="Requester" runat="server" type="text" id="RequesterInput" autocomplete="off" min="0" placeholder="¿Quién solicita?"/>
                            </div>--%>

                            <%--<asp:Button ID="AddButton" runat="server" Text="Solicitar" CssClass="btn btn-success" />--%>
                        <div class="btn-group">
                            <asp:Button ID="CancelRequestButton" runat="server"  Text="Cancelar" CssClass="btn btn-danger" OnClick="Cancel_Click" />
                            <asp:Button ID="SendRequestButton" runat="server" Text="Enviar" CssClass="btn btn-success" OnClick="SendRequest_Click" />
                        </div>
                             
                    </div>

                    <div id="AsignRepairman" visible="false" runat="server">
                        <h4>Asignar Reparador</h4>
                            <div class="from-label-grupo">
                                <input name="NP" runat="server" type="text" id="Text2" autocomplete="off" min="0" placeholder="PN"/>
                            </div>
                            <div class="from-label-grupo">
                                <input name="Repairman" runat="server" type="text" id="Text3" autocomplete="off" min="0" placeholder="Reparador"/>
                            </div>
<%--                            <div class="from-label-grupo">
                                <input name="Requester" runat="server" type="text" id="RequesterInput" autocomplete="off" min="0" placeholder="¿Quién solicita?"/>
                            </div>--%>

                            <%--<asp:Button ID="AddButton" runat="server" Text="Solicitar" CssClass="btn btn-success" />--%>
                        <div class="btn-group">
                            <asp:Button ID="Button1" runat="server"  Text="Cancelar" CssClass="btn btn-danger" OnClick="Cancel_Click" />
                            <asp:Button ID="Button2" runat="server" Text="Enviar" CssClass="btn btn-success" OnClick="SendRequest_Click" />
                        </div>
                             
                    </div>

                     <label id="errorPlanner" style="color:#c10000; text-align: center;"  runat="server"></label>
                </div>
            </div>
        </div>
    </section>

</asp:Content>


