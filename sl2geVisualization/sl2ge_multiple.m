function varargout = sl2ge_multiple(varargin)
% MATLAB_Simulink_CloseUp MATLAB code for MATLAB_Simulink_CloseUp.fig
%      MATLAB_Simulink_CloseUp, by itself, creates a new MATLAB_Simulink_CloseUp or raises the existing
%      singleton*.
%
%      H = MATLAB_Simulink_CloseUp returns the handle to a new MATLAB_Simulink_CloseUp or the handle to
%      the existing singleton*.
%
%      MATLAB_Simulink_CloseUp('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATLAB_Simulink_CloseUp.M with the given input arguments.
%
%      MATLAB_Simulink_CloseUp('Property','Value',...) creates a new MATLAB_Simulink_CloseUp or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MATLAB_Simulink_CloseUp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MATLAB_Simulink_CloseUp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MATLAB_Simulink_CloseUp

% Last Modified by GUIDE v2.5 09-Apr-2014 16:45:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MATLAB_Simulink_CloseUp_OpeningFcn, ...
                   'gui_OutputFcn',  @MATLAB_Simulink_CloseUp_OutputFcn, ...
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

end

% --- Executes just before MATLAB_Simulink_CloseUp is made visible.
function MATLAB_Simulink_CloseUp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MATLAB_Simulink_CloseUp (see VARARGIN)

% Open ActiveX-Control from Microsoft-Internet-Explorer
handles.ie1 = actxcontrol('Shell.Explorer.2',[0   400 1120 605]);
handles.ie2 = actxcontrol('Shell.Explorer.2',[0   0   560  400]);

projectRoot = evalin('base','pwd');

eval(sprintf('Navigate(handles.ie1,''file:%s'');',fullfile(projectRoot,'sl2geVisualization','webServices','sl2ge_autruism_v1.html')))
eval(sprintf('Navigate(handles.ie2,''file:%s'');',fullfile(projectRoot,'sl2geVisualization','webServices','sl2ge_autruism_v2.html')))

% Get the Document
handles.myDoc1 = handles.ie1.Document;
handles.myDoc2 = handles.ie2.Document;

% Choose default command line output for MATLAB_Simulink_CloseUp
handles.output = hObject;
 
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MATLAB_Simulink_CloseUp wait for user response (see UIRESUME)
% uiwait(handles.figure1);

setappdata(0,'figureHandle',gcf);

end


% --- Outputs from this function are returned to the command line.
function varargout = MATLAB_Simulink_CloseUp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, ~)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes during object creation, after setting all properties.
function elevAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elevAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate elevAxes
elevHandles = elevFigure(hObject);
elevHandles.axes = hObject;
setappdata(gcf,'elevHandles',elevHandles);
handles.elevHandles = elevHandles;
guidata(hObject, handles);
end


% % --- Executes during object creation, after setting all properties.
% function velAxes_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to velAxes (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: place code in OpeningFcn to populate velAxes
% velHandles = velAxes(hObject);
% velHandles.axes = hObject;
% setappdata(gcf,'velHandles',velHandles);
% handles.velHandles = velHandles;
% guidata(hObject, handles);
% end

% --- Executes during object creation, after setting all properties.
function accAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to accAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate accAxes
accHandles = accAxes(hObject);
accHandles.axes = hObject;
setappdata(gcf,'accHandles',accHandles);
handles.accHandles = accHandles;
guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function tagSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tagSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
textHandleSpeed     = hObject;
setappdata(gcf,'textHandleSpeed',textHandleSpeed);
end

% --- Executes during object creation, after setting all properties.
function tagDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tagDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
textHandleDist     = hObject;
setappdata(gcf,'textHandleDist',textHandleDist);
end

% --- Executes during object creation, after setting all properties.
function tagTravelTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tagTravelTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
textHandleTime     = hObject;
setappdata(gcf,'textHandleTime',textHandleTime);
end

% --- Executes during object creation, after setting all properties.
function text14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
textHandleTimeTD     = hObject;
setappdata(gcf,'textHandleTimeTD',textHandleTimeTD);
end


% --- Executes during object creation, after setting all properties.
function clockAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clockAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate clockAxes
endTime = evalin('base','logsout.getElement(''aX'').Values.Time(end)');
startTime = evalin('base','startTime');
plotTimePie(startTime,endTime-startTime, hObject);
clockHandles.axes = hObject;
setappdata(gcf,'clockHandles',clockHandles);
handles.clockHandles = clockHandles;
guidata(hObject, handles);
end