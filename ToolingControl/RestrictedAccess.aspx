<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="RestrictedAccess.aspx.cs" Inherits="ToolingControl.RestrictedAccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <link href="css/RestrictedAccess.css" rel="stylesheet"/>
    <section class="Control">
        <div class="hero"></div>
        <div class="row">

            <div class="wrap-login">

                <div class="content-login">
                    <div>
                        <h1 style="color:black; text-align: center;">¡Acceso Restringido!</h1>
                        <h2 style="color:#c10000; text-align: center;">No tines permiso para ver esta página</h2>
                    </div>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
