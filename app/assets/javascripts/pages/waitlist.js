Paloma.controller('Waitlists', {
  index: function() {
    attachButtonEvent();
    attachEmailEvent();
    activateButton();

    function attachEmailEvent() {
      var form   = document.querySelector('[data-wait-list-form] form');
      var input = document.querySelector('[data-wait-list-form] input#email-capture');
      input.addEventListener('keydown', function(e) {
        var key = e.keyCode || e.which;
        if (key == 13) {
          console.log("enter!");
          e.preventDefault();
          deactivateButton();
          onFormValid(form);
        }
      }, false);
    }

    function attachButtonEvent() {
      var form   = document.querySelector('[data-wait-list-form] form');
      var button = document.querySelector('[data-wait-list-form] a.button.next');
      var input  = document.querySelector('[data-wait-list-form] input#email-capture');
      button.addEventListener('click', function (e) {
        console.log("join clicked!");
        e.preventDefault();
        deactivateButton();
        onFormValid(form);
      }, false);
    }

    function activateButton(){
      var input = document.querySelector('[data-wait-list-form] input#email-capture');
      var button = document.querySelector('[data-wait-list-form] a.button.next');

      $(input).on("change paste", function(){
        if($(input).parsley().isValid()){
          button.classList.remove("inactive");
        }
      })
      $(input).on("keyup", function(e){
        if(e.which != 13){
          if($(input).parsley().isValid()){
            button.classList.remove("inactive");
          }
        }
      })
    }

    function deactivateButton() {
      var button = document.querySelector('[data-wait-list-form] a.button.next');
      button.classList.add("inactive");
    }

    function onFormValid(form) {
      var parsleyForm = $(form).parsley();
      if(parsleyForm.isValid()) {
        var input   = form.querySelector('#email-capture');
        var button  = form.querySelector('a.button.next');
        button.classList.add('inactive');
        createWaitlistedUser(input.value);
      };
    }

    function createWaitlistedUser(email) {
      var data = { user: { email: email }, user_agent: navigator.userAgent };
      $.ajax({
        type: "POST",
        url: '/waitlist',
        dataType: "json",
        data: JSON.stringify(data),
        success: function (data) {
          window.location = data.url;
        },
        contentType: "application/json"
      });
    }
  }
});
