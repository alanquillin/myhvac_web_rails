function initSenorMeasurementGrip(sensor_id){
    var grid = $('#sensorMeasurementGrid');
    grid.empty();
    grid.pgGrid({
        url: '/sensors/' + sensor_id + '/measurements/temperatures.json',
        dataModel: [
            { name: 'Temp', index: 'data', sortable: false},
            { name: 'Recorded Date', index: 'recorded_date'}
        ],
        title: '',
        dataItemIndex: 'measurements',
        sortColumn: 'recorded_date',
        sortDirection: 'DESC'
    }, true);
}