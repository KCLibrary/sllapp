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
    var base_uri = $('#datepicker').data('sll-base-url') + '/';
    window.location.href = base_uri + formatDateString(e.date);
  });
  
  $('.time-helper').on('click', function(e) {
    $(this).closest('li').find('[type="checkbox"]').first().trigger('click');
  });


  

});
