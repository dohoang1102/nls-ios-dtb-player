$(function() {
    $('.files ul li').click(function() {
        $(this).parent('ul').find('.selected').removeClass('selected')
        $(this).addClass('selected')
    });

    var file = location.hash
    if (!file) {
        file = $.trim($('.files ul li a').attr('href'))
        location.hash = file
    }
    $('#file-' + file.replace(/^#/, '')).addClass('selected')

    $('.files ul li a').each(function() {
        var file = $.trim($(this).attr('href').replace(/^#/,''))
        var error = $('#' + file + ' .error').length
        var warning = $('#' + file + ' .warning').length
        var fail = $('#' + file + ' .fail').length
        warning += $('#' + file + ' .issue').length

        function p(count, singular, plural) {
            return "<li>" + count + " " + (count == 1 ? singular : (plural || singular + "s")) + "</li>"
        }

        var details = []
        details.push('<ul>')
        details.push(p(fail, 'failure'));
        details.push(p(error, 'error'));
        details.push(p(warning, 'warning'));
        details.push('</ul>')
        $(this).toggleClass('pass', (error + warning + fail) === 0);
        $(this).toggleClass('warn', (error + fail) === 0 && warning > 0);
        $(this).toggleClass('fail', (error + fail) > 0);
        $(this).append(details.join(''));
    });

    $('#results .device > ul > li > h1').click(function() {
        $(this).parent('li').toggleClass('expanded');
    });
});
