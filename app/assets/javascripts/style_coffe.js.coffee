jQuery ->
  Morris.Line
    element: 'graph'
    data: $('#graph').data('activity')
    xkey: 'created_at'
    ykeys: ['count']
    labels: ['Activities']