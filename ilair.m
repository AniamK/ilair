function varargout = ilair(varargin)
% ILAIR MATLAB code for ilair.fig
%      ILAIR, by itself, creates a new ILAIR or raises the existing
%      singleton*.
%
%      H = ILAIR returns the handle to a new ILAIR or the handle to
%      the existing singleton*.
%
%      ILAIR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ILAIR.M with the given input arguments.
%
%      ILAIR('Property','Value',...) creates a new ILAIR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ilair_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ilair_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ilair

% Last Modified by GUIDE v2.5 01-May-2018 23:32:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ilair_OpeningFcn, ...
                   'gui_OutputFcn',  @ilair_OutputFcn, ...
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


% --- Executes just before ilair is made visible.
function ilair_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ilair (see VARARGIN)

% Choose default command line output for ilair
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ilair wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ilair_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_btn.
function browse_btn_Callback(hObject, eventdata, handles)
% hObject    handle to browse_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Step Load Image
[filename, pathname]=uigetfile('*.*','Choose an image');
imageData=imread(strcat(pathname,filename));
%setappdata(handles.axes1,'imageData',imageData);
axes(handles.axes1);
imshow(imageData);

[center,radius] = findPupil(imageData);
center = round(center,0);
radius = round(radius,0);
set(handles.xp_edit,'string',num2str(center(1)));
set(handles.yp_edit,'string',num2str(center(2)));
set(handles.rp_edit,'string',num2str(radius));
axes(handles.axes2);
imshow(imageData);
h = viscircles(center,radius);
%disp(center);
%disp(radius);

[ci,cp,out] = thresh(imageData,110,160);
ci = round(ci,0);
set(handles.xi_edit,'string',num2str(ci(2)));
set(handles.yi_edit,'string',num2str(ci(1)));
set(handles.ri_edit,'string',num2str(ci(3)));
h = viscircles([ci(2) ci(1)],ci(3));

%[ring,parr]=normaliseiris(imageData,ci(1),ci(2),ci(3),center(1),center(2),radius,'normal.bmp',100,300);
[ring,parr]=normaliseiris(imageData,ci(2),ci(1),ci(3),center(1),center(2),radius,'normal.bmp',100,300);
parr=adapthisteq(parr);
axes(handles.axes3);
imshow(parr);

parr = imresize(parr,[227 227]); % resize
imageNormal = cat(3, parr, parr, parr); % convert 2d image to 3d image
imshow(imageNormal);
imwrite(imageNormal,'imageOutput/imageData.jpg');

disp('test stage')
load trainImage.mat;
%load loadImage.mat;
label = classify(netTransfer,imageNormal)
label = getOutput(label);
%disp(label);
set(handles.result_edit,'string',label);


function xp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xp_edit as text
%        str2double(get(hObject,'String')) returns contents of xp_edit as a double


% --- Executes during object creation, after setting all properties.
function xp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to yp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yp_edit as text
%        str2double(get(hObject,'String')) returns contents of yp_edit as a double


% --- Executes during object creation, after setting all properties.
function yp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xi_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xi_edit as text
%        str2double(get(hObject,'String')) returns contents of xi_edit as a double


% --- Executes during object creation, after setting all properties.
function xi_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yi_edit_Callback(hObject, eventdata, handles)
% hObject    handle to yi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yi_edit as text
%        str2double(get(hObject,'String')) returns contents of yi_edit as a double


% --- Executes during object creation, after setting all properties.
function yi_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rp_edit as text
%        str2double(get(hObject,'String')) returns contents of rp_edit as a double


% --- Executes during object creation, after setting all properties.
function rp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ri_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ri_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ri_edit as text
%        str2double(get(hObject,'String')) returns contents of ri_edit as a double


% --- Executes during object creation, after setting all properties.
function ri_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ri_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function result_edit_Callback(hObject, eventdata, handles)
% hObject    handle to result_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result_edit as text
%        str2double(get(hObject,'String')) returns contents of result_edit as a double


% --- Executes during object creation, after setting all properties.
function result_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in train_btn.
function train_btn_Callback(hObject, eventdata, handles)
% hObject    handle to train_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trainImages();
