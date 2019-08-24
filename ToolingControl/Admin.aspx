<%@ Page Language="C#"  MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="ToolingControl.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceholder1" runat="server" >
    
    <section class="control">
        <div class="hero"></div>
        <div class="wrap">
            <div class="container">
                <div class="content">
                    <%-- Users Header --%>
                    <div class="header fondo-azul">
                        <h1>Users</h1>
                    </div>
                    <div class="row" id="divUsuarios" runat="server">

                        <div class="col-lg-4">
                            <h4>Usuarios</h4>
                            <%--<div class="form-label-group">
                                <label>User:</label>
                                <input type="text" id="UserInput" runat="server" maxlength="30" autocomplete="off" placeholder="User" />
                            </div>--%>

                            <input id="UserInput" runat="server" type="text" placeholder="Usuario" />

                            <%--<div class="form-label-group">
                                <input type="text" id="email" runat="server" maxlength="80" autocomplete="off" placeholder="Email" />
                                <label for="ContentPlaceHolder1">Email</label>
                            </div>--%>

                            <select id="RolSelect" runat="server">
                                <option value="0">Rol</option>
                                <option value="TOOLING">Tooling</option>
                                <option value="PLANNING">Planeación</option>
                                <option value="PRODUCTION">Producción</option>
                                <option value="QUALITY">Calidad</option>
                            </select>

                            <asp:Button ID="AddUserButton" runat="server" Text="Agregar" OnClick="AddUserButton_Click" CssClass="btn btn-info" />
                            <label id="errorUsuario" runat="server" class="error"></label>
                        </div>
                        <div class="col-lg-8">
                            <div class="fondo-tabla">
                                <div id="Div1" runat="server">

                                    <div id="DivRoot">
                                        <div style="overflow: hidden;" id="DivHeaderRow">
                                        </div>
                                        <div style="overflow: scroll; height: 400px;" onscroll="OnScrollDiv(this)" id="DivMainContent">
                                            <asp:GridView ID="UsersGrid" runat="server" DataKeyNames="ID" AutoGenerateColumns="False" ForeColor="#333333" ShowFooter="True" Width="100%" CellPadding="4" GridLines="None">
                                                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="User" SortExpression="Usuario">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label3" runat="server" Text='<%# Bind("UserID") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Rol">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label7" runat="server" Text='<%# Bind("Rol") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    
                                                </Columns>
                                                <EditRowStyle BackColor="#999999" />
                                                <FooterStyle />
                                                <HeaderStyle CssClass="t-tabla fondo-naranja" />
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
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
        
</asp:Content>