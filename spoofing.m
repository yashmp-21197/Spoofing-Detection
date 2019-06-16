function varargout = spoofing(varargin)
% SPOOFING MATLAB code for spoofing.fig
%      SPOOFING, by itself, creates a new SPOOFING or raises the existing
%      singleton*.
%
%      H = SPOOFING returns the handle to a new SPOOFING or the handle to
%      the existing singleton*.
%
%      SPOOFING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPOOFING.M with the given input arguments.
%
%      SPOOFING('Property','Value',...) creates a new SPOOFING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spoofing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spoofing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spoofing

% Last Modified by GUIDE v2.5 05-May-2018 11:31:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spoofing_OpeningFcn, ...
                   'gui_OutputFcn',  @spoofing_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before spoofing is made visible.
function spoofing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spoofing (see VARARGIN)

% Choose default command line output for spoofing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spoofing wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global LMS_net;
global RLMS_net;
global IF_net;
global GD_net;
global MGD_net;
global BPD_net;
global init_status;
global train_status;
global simulate_data;

init_status = false;
train_status = false;

addpath('DATABASE\protocol\CM_protocol');
simulatefile_name = 'DATABASE\protocol\CM_protocol\cm_evaluation.txt';
    
try
    fileID = fopen(simulatefile_name,'r');
    simulate_data = textscan(fileID,'%s %s %s %s');
    fclose(fileID);
catch
    rethrow(lasterror);
end

% --- Outputs from this function are returned to the command line.
function varargout = spoofing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in create_networks.
function create_networks_Callback(hObject, eventdata, handles)
% hObject    handle to create_networks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
init_networks(handles);

% --- Executes on button press in train_networks.
function train_networks_Callback(hObject, eventdata, handles)
% hObject    handle to train_networks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global init_status;
global train_status;

if init_status
    train_networks(handles);
...    set(hObject,'BackgroundColor','white');
else
    msgbox('You have to first create networks.', 'Error','error');
end

% --- Executes on button press in simulate_networks.
function simulate_networks_Callback(hObject, eventdata, handles)
% hObject    handle to simulate_networks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global init_status;
global train_status;

if (init_status && train_status)
    simulate_networks(handles);
else
    msgbox('You have to first create and then train networks.', 'Error','error');
end

% --- Executes on button press in find_accuracy.
function find_accuracy_Callback(hObject, eventdata, handles)
% hObject    handle to find_accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global init_status;
global train_status;

if (init_status && train_status)
    cal_accuracy(handles);
else
    msgbox('You have to first create and train networks.', 'Error','error');
end
