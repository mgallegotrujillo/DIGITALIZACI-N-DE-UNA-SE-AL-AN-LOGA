function varargout = Serial(varargin)
% SERIAL MATLAB code for Serial.fig
%      SERIAL, by itself, creates a new SERIAL or raises the existing
%      singleton*.
%
%      H = SERIAL returns the handle to a new SERIAL or the handle to
%      the existing singleton*.
%
%      SERIAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SERIAL.M with the given input arguments.
%
%      SERIAL('Property','Value',...) creates a new SERIAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Serial_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Serial_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Serial

% Last Modified by GUIDE v2.5 05-Mar-2019 15:38:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Serial_OpeningFcn, ...
    'gui_OutputFcn',  @Serial_OutputFcn, ...
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


% --- Executes just before Serial is made visible.
function Serial_OpeningFcn(hObject, eventdata, handles, varargin)
global GET_DataR GET_DataW G_axes1 tmax DataPlt ctb cin
GET_DataR=handles.ET_DataR;
GET_DataW=handles.ET_DataW;
G_axes1=handles.axes1;
ctb=0;
cin=0;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Serial (see VARARGIN)

% Choose default command line output for Serial
handles.output = hObject;

%set Ts
tmax=str2num(get(handles.ET_tmax,'String'));
Ts=2/500;
Ts=0.1;
DataPlt=[];
% DataPlt=zeros(1,tmax);

%set  Plot
n=1:Ts:tmax;
axes(handles.axes1)
xlim([0 tmax])
ylim([0 3.3])

% set up timer
% global t
% t = timer;
% t.TimerFcn = @nada;
% t.ExecutionMode = 'fixedRate';
% t.Period = Ts;
% t.BusyMode = 'drop';

% looking for available serial ports
% (Instrument Control Toolbox required)
p = instrhwinfo('serial');
set(handles.PUPM_COM, 'String',p.AvailableSerialPorts);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Serial wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Serial_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function nada()
x=1;






% --- Executes on selection change in PUPM_BaudRate.
function PUPM_BaudRate_Callback(hObject, eventdata, handles)
% hObject    handle to PUPM_BaudRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PUPM_BaudRate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PUPM_BaudRate


% --- Executes during object creation, after setting all properties.
function PUPM_BaudRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PUPM_BaudRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PUPM_COM.
function PUPM_COM_Callback(hObject, eventdata, handles)
% hObject    handle to PUPM_COM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PUPM_COM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PUPM_COM


% --- Executes during object creation, after setting all properties.
function PUPM_COM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PUPM_COM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TGB_Conect.
function TGB_Conect_Callback(hObject, eventdata, handles)
global port t
get(handles.TGB_Conect,'Value')
if get(handles.TGB_Conect,'Value')==1
    
    puertos = get(handles.PUPM_COM,'String');
    selectedIndex = get(handles.PUPM_COM,'Value');
    selectedItem = puertos{selectedIndex};
    port = serial(selectedItem);
    
    BaudRates = get(handles.PUPM_BaudRate,'String');
    selectedIndex = get(handles.PUPM_BaudRate,'Value');
    selectedItem = BaudRates{selectedIndex};
    port.BaudRate=str2num(selectedItem);
    
    port.BytesAvailableFcnCount = 2;
    port.BytesAvailableFcnMode = 'byte';
    port.BytesAvailableFcn =@ReadData;
    fopen(port);
    
%     start(t);
    
    set(handles.TGB_Conect,'String','ON')
elseif get(handles.TGB_Conect,'Value')==0
    
%     stop(t);
    stopasync(port)
    fclose(port);
    delete(port);
    
    set(handles.TGB_Conect,'String','OFF')
end


% hObject    handle to TGB_Conect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TGB_Conect


% --- Executes on button press in BTN_DataW.
function BTN_DataW_Callback(hObject, eventdata, handles)
SendData(hObject, eventdata, handles);
% hObject    handle to BTN_DataW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ET_DataR_Callback(hObject, eventdata, handles)
% hObject    handle to ET_DataR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ET_DataR as text
%        str2double(get(hObject,'String')) returns contents of ET_DataR as a double


% --- Executes during object creation, after setting all properties.
function ET_DataR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ET_DataR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ET_DataW_Callback(hObject, eventdata, handles)
% hObject    handle to ET_DataW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ET_DataW as text
%        str2double(get(hObject,'String')) returns contents of ET_DataW as a double


% --- Executes during object creation, after setting all properties.
function ET_DataW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ET_DataW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ET_tmax_Callback(hObject, eventdata, handles)
global DataPlt tmax
DataPlt=[];
tmax=str2num(get(handles.ET_tmax,'String'));

% hObject    handle to ET_tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ET_tmax as text
%        str2double(get(hObject,'String')) returns contents of ET_tmax as a double


% --- Executes during object creation, after setting all properties.
function ET_tmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ET_tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SendData(hObject, eventdata, handles)
disp('envio')
global port GET_DataW
if port.BytesToOutput == 0
    values_to_send = uint8(2.55 * (100 - 25)); % scale color values to 255..0 uint8 range
    fwrite(port, get(GET_DataW,'String'), 'uint8', 'async'); % send prepared color values over serial to Arduino
end
function ReadData(hObject, eventdata, handles)
% disp('recibido')
global DataR port GET_DataR G_axes1 DataPlt tmax ctb cin
% 
% 
% DataRr = fread(port,1);
%  DataR=DataRr*3.3/(2^16 - 1)
%  if(length(DataPlt)<tmax)
%      DataPlt=[DataPlt DataR];
% drawnow
%      stem(G_axes1,1:length(DataPlt),DataPlt)
%      
%  else
%      DataPlt=circshift(DataPlt,[1 -1]);
%      DataPlt(end)=DataR;
% drawnow
%      stem(G_axes1,1:tmax,DataPlt)
%      
%  end
 
 
 DataR = fread(port, 1,'uint8')
 set(GET_DataR,'String',num2str(DataR));

switch ctb
    case -1
        if DataR==65
            ctb=1;
        end
    case 0    
        ctb=2;
        cin=DataR;
    case 2
        DataR= typecast(uint8([cin DataR]), 'uint16');
        % fread(port,1,'char')
        DataR=double(DataR)*3.3/(2^16 - 1);
        if(length(DataPlt)<tmax)
            DataPlt=[DataPlt DataR];
            drawnow
            stem(G_axes1,1:length(DataPlt),DataPlt)
        else
            DataPlt=circshift(DataPlt,[1 -1]);
            DataPlt(end)=DataR;
            drawnow
            stem(G_axes1,1:tmax,DataPlt)
        end
        ctb=0;
    otherwise
        ctb=0;
        
end
ylim(G_axes1,[0 3.3])





function SendDataT(hObject, eventdata, handles)
disp('envio')
global port GET_DataW
if port.BytesToOutput == 0
    values_to_send = uint8(2.55 * (100 - 25)); % scale color values to 255..0 uint8 range
    fwrite(port, get(GET_DataW,'String'), 'uint8', 'async'); % send prepared color values over serial to Arduino
end
% aux=de2bi(DataR,8);
% DataR=bi2de([aux(9:16) aux(1:8)],2)%la cosa es que cuando tenga algo nuebo en el bufer entra a leer


% --- Executes on button press in CB_TimerM.
function CB_TimerM_Callback(hObject, eventdata, handles)
global t
if get(handles.CB_TimerM,'Value')==0
    t.TimerFcn = @nada;   
else
    t.TimerFcn = @SendDataT; 
end
% hObject    handle to CB_TimerM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_TimerM
