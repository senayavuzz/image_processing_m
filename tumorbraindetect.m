function varargout = tumorbraindetect(varargin)
% TUMORBRAINDETECT MATLAB code for tumorbraindetect.fig
%      TUMORBRAINDETECT, by itself, creates a new TUMORBRAINDETECT or raises the existing
%      singleton*.
%
%      H = TUMORBRAINDETECT returns the handle to a new TUMORBRAINDETECT or the handle to
%      the existing singleton*.
%
%      TUMORBRAINDETECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TUMORBRAINDETECT.M with the given input arguments.
%
%      TUMORBRAINDETECT('Property','Value',...) creates a new TUMORBRAINDETECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tumorbraindetect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tumorbraindetect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tumorbraindetect

% Last Modified by GUIDE v2.5 02-Apr-2023 12:48:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tumorbraindetect_OpeningFcn, ...
                   'gui_OutputFcn',  @tumorbraindetect_OutputFcn, ...
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


% --- Executes just before tumorbraindetect is made visible.
function tumorbraindetect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tumorbraindetect (see VARARGIN)

% Choose default command line output for tumorbraindetect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tumorbraindetect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tumorbraindetect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img1 img2

[path, nofile] = imgetfile();

if nofile
    msgbox(sprintf('Image not found !!!'), 'Error', 'Warning');
    return
end

img1 = imread(path);

img1 = im2double (img1);

img2 = img1;

axes(handles.axes1);
imshow(img1);

title('Brain MRI')

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1
axes(handles.axes2); 
bw = im2bw (img1, 0.7);
label = bwlabel (bw);

stats = regionprops(label, 'solidity', 'Area');
density = [stats. Solidity];
area = [stats.Area];
high_dense_area = density > 0.5;
max_area = max(area(high_dense_area));
tumor_label = find(area == max_area);
tumor = ismember (label, tumor_label);

se = strel ('square', 5); 
tumor = imdilate (tumor, se)

Bound = bwboundaries(tumor, 'noholes');

imshow(img1);
hold on

for i = 1: length (Bound)
    plot (Bound {i} (:,2), Bound{i} (:,1), 'y', 'linewidth', 1.75)
end

title('Tumor Detected!!!');

hold off
axes(handles.axes)
