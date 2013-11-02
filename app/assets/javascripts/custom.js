$(document).ready(function() {

  function pad(s) {
    return (s < 10 ? '0' : '') + s;
  }

  function formatDateString(date) {
    return [
      date.getUTCFullYear(),
      pad(date.getUTCMonth() + 1),
      pad(date.getUTCDate())
    ].join('-');  
  }

	$('#datepicker').datepicker().on('changeDate', function(e) {    
    window.location.href = $('#datepicker').data('sll-base-url') + '/' + formatDateString(e.date);
  });
  
  /*
  var _flag = true;
  $('.sll-time-fields input:checkbox').on('change', function(e) {
    var that = $(this);
    var _select = $('.sll-time-fields li:has(input:checked)');

    if ( _select.length > 1 && _flag) {
      var first = _select.first();
      var last = _select.last();
      _flag = false;
      first.nextUntil(last).find('input:checkbox').prop('checked', true);
      if ( $(_select.selector).length > 3 && that.is(':checked') == true) {
        alert("Please select at most three consecutive hour blocks");
      }
      _flag = true;
    }
  });
  */
  //$('.selectable').selectable();
  
  /*
  $('#sll-available-dates_year, #sll-available-dates_month, #sll-available-dates_day').on("change", function(e) {
    var _date = new Date(
      parseInt($('#sll-available-dates_year').val()),
      parseInt($('#sll-available-dates_month').val()) - 1,
      parseInt($('#sll-available-dates_day').val())
    );
    window.location.href = $('#datepicker').data('sll-base-url') + '/' + formatDateString(_date);
  });
  */
  

});
