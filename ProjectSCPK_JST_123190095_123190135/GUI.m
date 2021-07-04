function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 13-Jun-2021 13:28:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
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

    [nama_file,nama_path] = uigetfile({'*.jpg*'});
     
    if ~isequal(nama_file,0)
        Img = imread(fullfile(nama_path,nama_file));
        axes(handles.axes2)
        imshow(Img)
        handles.Img = Img;
        guidata(hObject,handles)
         
        axes(handles.axes3)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
         
        axes(handles.axes4)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
         
        axes(handles.axes5)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
         
        axes(handles.axes6)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
         
        set(handles.uitable1,'Data',[])
        set(handles.edit1,'String','')
    else
        return
    end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    Img = im2double(handles.Img);
     
    % Ekstraksi Ciri Warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
    
    Red = mean2(R);
    Green = mean2(G);
    Blue = mean2(B);
    
    % Ekstraksi Ciri Tekstur Filter Gabor
    I = (rgb2gray(Img));
    wavelength = 4;
    orientation = 90;
    [mag,~] = imgaborfilt(I,wavelength,orientation);
         
    H = imhist(mag)';
    H = H/sum(H);
    I = (0:255)/255;
     
    Mean = mean2(mag);
    Entropy = -H*log2(H+eps)';
    Varian = (I-Mean).^2*H';
     
    ShowRed = cat(3,R,G*0,B*0);
    ShowGreen = cat(3,R*0,G,B*0);
    ShowBlue = cat(3,R*0,G*0,B);
     
    axes(handles.axes3)
    imshow(ShowRed)

    axes(handles.axes4)
    imshow(ShowGreen)
     
    axes(handles.axes5)
    imshow(ShowBlue)
      
    axes(handles.axes6)
    imshow(mag,[])
 
    data = cell(6,2);
    data{1,1} = 'Red';
    data{2,1} = 'Green';
    data{3,1} = 'Blue';
    data{4,1} = 'Mean';
    data{5,1} = 'Entropy';
    data{6,1} = 'Varians';
    data{1,2} = Red;
    data{2,2} = Green;
    data{3,2} = Blue;
    data{4,2} = Mean;
    data{5,2} = Entropy;
    data{6,2} = Varian;
     
    set(handles.uitable1,'Data',data,'ForegroundColor',[0 0 0])
     
    bell_pepper = [Red; Green; Blue; Mean; Entropy; Varian];
     
    handles.bell_pepper = bell_pepper;
    guidata(hObject, handles)
     
set(handles.edit1,'String','')



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    bell_pepper = handles.bell_pepper;
    load net
    result = round(sim(net,bell_pepper))
     
    if result == 0
        bellpepper_type = 'GREEN BELL PEPPER';
    elseif result == 1
        bellpepper_type = 'RED BELL PEPPER';
    else
        bellpepper_type = 'unknown';
    end
     
set(handles.edit1,'String',bellpepper_type);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
