var timer;
var tempGage = null;
var dashboardPaths = [];
var autoRefresh = true;

function updateSystemDetails(){
    if(autoRefresh == false)
        return;

    return $.ajax({
        type: "GET",
        url: "/dashboard.js"
    }).error(function(jqXHR, textStatus, errorThrown){
        if(jqXHR.status>0){
            setdashboardErrorMsg(textStatus + ' (' + errorThrown + ')');
        }
        else{
            setdashboardErrorMsg('Unable to connect to the service... Connection refused');
        }
        $('#dashboardError').show();
        setUpdateSystemDetailsTimer(60000);
    });
}

function setdashboardErrorMsg(msg){
    $('#dashboardErrorMessage').text(msg);
    $('#dashboardErrorTime').text(new Date().toLocaleString());
}

function setTempGage(temp, force){
    force = typeof force !== 'undefined' ? force : false;
    if(tempGage == null || force){
        tempGage = new JustGage({
            id: 'gauge',
            value: temp,
            min: 30,
            max: 100,
            title: 'Aggregate Temp',
            levelColors: ['#c1e2b3', '#2b542c'],
            symbol: '° F',
            shadowOpacity: .2,
            startAnimationTime: 1000,
            startAnimationType: 'bounce',
            refreshAnimationType: 'bounce',
            decimals: 1,
            gaugeWidthScale:.5
        });
    }
    else{
        tempGage.refresh(temp);
    }
}

function showRoomMeasurementModal(room_id){
    $('#roomTempHistory').modal('show');
    initRoomMeasurementGrip(room_id);
}

function setUpdateSystemDetailsTimer(timeout){
    timeout = typeof timeout !== 'undefined' ? timeout : 25000;
    var isDashboard = false;

    for(i = 0; i < dashboardPaths.length; i++){
        if(window.location.pathname == dashboardPaths[i]){
            isDashboard = true;
        }
    }

    if(isDashboard == true && autoRefresh == true) {
        timer = setTimeout(updateSystemDetails, timeout);
    }
}

function switchAutoUpdate(state){
    if (state) {
        autoRefresh = true;
        setUpdateSystemDetailsTimer();
    } else {
        autoRefresh = false;
        timer = null;
    }
}

function setAutoUpdateSwitch(){
    var autoUpdateSwitch = $('#dashboardAutoUpdate');
    autoUpdateSwitch.bootstrapSwitch();
    autoUpdateSwitch.change(function(){
        switchAutoUpdate($(this).is(':checked'));
    });
    autoUpdateSwitch.on('switchChange.bootstrapSwitch', function(event, state) {
        switchAutoUpdate(state);
    });
}

function showSystemSettingsEditModal(mode, program, cool_val, heat_val){
    if(mode == '' || mode == 'Unknown')
        mode = 'Off';

    setSystemSystemEditValues(mode, program, cool_val, heat_val);
    setSystemSettingsEditSectionVisibility(mode);
    $('#submitEditSystemSettings').prop('disabled', true);
    $('#setSystemProgramModal').modal('show');
}

function hideSystemSettingsEditModal() {
    $('#setSystemProgramModal').modal('hide');
}

function initRoomMeasurementGrip(room_id){
    var grid = $('#roomMeasurementGrid');
    grid.empty();
    grid.pgGrid({
        url: '/rooms/' + room_id + '/measurements/temperatures.json',
        dataModel: [
            { name: 'Temp', index: 'data', sortable: false},
            { name: 'Sensor Id', index: 'sensor_id'},
            { name: 'Recorded Date', index: 'recorded_date'}
        ],
        title: '',
        dataItemIndex: 'measurements',
        sortColumn: 'recorded_date',
        sortDirection: 'DESC'
    }, true);
}

function enableEditSystemSettingSubmit(){
    $('#submitEditSystemSettings').prop('disabled', false);
}

function systemSettingsModeChanged(){
    setSystemSettingsEditSectionVisibility($('#systemModeSelector option:selected').text());
    enableEditSystemSettingSubmit();
}

function setSystemSettingsEditSectionVisibility(mode){
    var prog_selector = $('#editSystemSettingProgramContent');
    var cool_setting = $('#editSystemSettingCoolTempContent');
    var heat_setting = $('#editSystemSettingHeatTempContent');

    prog_selector.hide();
    cool_setting.hide();
    heat_setting.hide();

    if(mode == 'Auto'){
        prog_selector.show();
    }

    if (mode == 'Manual'){
        cool_setting.show();
        heat_setting.show();
    }
}

function setSystemSystemEditValues(mode, program, cool_val, heat_val){
    $('#systemModeSelector option').filter(function() {
        return ($(this).text() == mode);
    }).prop('selected', true);

    if(program != 'Unknown'){
        $('#programSelector option').filter(function() {
            return ($(this).text() == program);
        }).prop('selected', true);
    }

    if(cool_val != 'Unknown'){
        $('#editSystemSettingCoolTemp').val(cool_val)
    }

    if(heat_val != 'Unknown'){
        $('#editSystemSettingHeatTemp').val(heat_val)
    }
}

function build_tooltips(){
    $('[data-toggle="tooltip"]').tooltip()
}