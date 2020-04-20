$('form').replaceWith("<%= j(render 'form', admin_session: @admin_session) %>")
