function [] = init_networks(handles)

    disp('initializing networks start.');
    global LMS_net;
    global RLMS_net;
    global IF_net;
    global GD_net;
    global MGD_net;
    global BPD_net;
    global init_status;
    global train_status;
    
    set(handles.create_networks,'Enable','off');
    set(handles.train_networks,'Enable','off');
    set(handles.simulate_networks,'Enable','off');
    set(handles.find_accuracy,'Enable','off');
        
        in1 = ones(256,1);
        in2 = zeros(256,1);
        
        epo = 10;
        config_inputs = [in1 in2];
        config_outputs = [1  0];
        
        LMS_net = feedforwardnet(2048,'traingd');
        LMS_net.layers{1}.transferFcn = 'logsig';
        LMS_net.layers{2}.transferFcn = 'logsig';
        LMS_net.performFcn = 'mse';
        LMS_net.divideFcn = 'dividetrain';
        LMS_net.trainParam.epochs=epo;
        LMS_net.biasConnect = [1;0];
        LMS_net = configure(LMS_net,config_inputs,config_outputs);
...        view(LMS_net);

        RLMS_net = feedforwardnet(2048,'traingd');
        RLMS_net.layers{1}.transferFcn = 'logsig';
        RLMS_net.layers{2}.transferFcn = 'logsig';
        RLMS_net.performFcn = 'mse';
        RLMS_net.divideFcn = 'dividetrain';
        RLMS_net.trainParam.epochs=epo;
        RLMS_net.biasConnect = [1;0];
        RLMS_net = configure(RLMS_net,config_inputs,config_outputs);
...        view(RLMS_net);

        IF_net = feedforwardnet(2048,'traingd');
        IF_net.layers{1}.transferFcn = 'logsig';
        IF_net.layers{2}.transferFcn = 'logsig';
        IF_net.performFcn = 'mse';
        IF_net.divideFcn = 'dividetrain';
        IF_net.trainParam.epochs=epo;
        IF_net.biasConnect = [1;0];
        IF_net = configure(IF_net,config_inputs,config_outputs);
...        view(IF_net);

        BPD_net = feedforwardnet(2048,'traingd');
        BPD_net.layers{1}.transferFcn = 'logsig';
        BPD_net.layers{2}.transferFcn = 'logsig';
        BPD_net.performFcn = 'mse';
        BPD_net.divideFcn = 'dividetrain';
        BPD_net.trainParam.epochs=epo;
        BPD_net.biasConnect = [1;0];
        BPD_net = configure(BPD_net,config_inputs,config_outputs);
...        view(BPD_net);

        GD_net = feedforwardnet(2048,'traingd');
        GD_net.layers{1}.transferFcn = 'logsig';
        GD_net.layers{2}.transferFcn = 'logsig';
        GD_net.performFcn = 'mse';
        GD_net.divideFcn = 'dividetrain';
        GD_net.trainParam.epochs=epo;
        GD_net.biasConnect = [1;0];
        GD_net = configure(GD_net,config_inputs,config_outputs);
...        view(GD_net);
        
        MGD_net = feedforwardnet(2048,'traingd');
        MGD_net.layers{1}.transferFcn = 'logsig';
        MGD_net.layers{2}.transferFcn = 'logsig';
        MGD_net.performFcn = 'mse';
        MGD_net.divideFcn = 'dividetrain';
        MGD_net.trainParam.epochs=epo;
        MGD_net.biasConnect = [1;0];
        MGD_net = configure(MGD_net,config_inputs,config_outputs);
...        view(MGD_net);
        
    init_status = true;
    train_status = false;
    
    disp('networks initializing completed.');
    set(handles.find_accuracy,'Enable','on');
    set(handles.simulate_networks,'Enable','on');
    set(handles.train_networks,'Enable','on');
    set(handles.create_networks,'Enable','on');
    
end