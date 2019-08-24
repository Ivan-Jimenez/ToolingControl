$(function () {
    $('[data-toggle="tooltip"]').tooltip();

    window.sr = ScrollReveal();
    sr.reveal('.content-login', {
        duration: 2000,
        origin: 'top',
        distance: '300px'
    });
});