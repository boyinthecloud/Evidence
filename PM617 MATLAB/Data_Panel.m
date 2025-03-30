function varargout = Data_Panel(varargin)
% DATA_PANEL MATLAB code for Data_Panel.fig
%      DATA_PANEL, by itself, creates a new DATA_PANEL or raises the existing
%      singleton*.
%
%      H = DATA_PANEL returns the handle to a new DATA_PANEL or the handle to
%      the existing singleton*.
%
%      DATA_PANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_PANEL.M with the given input arguments.
%
%      DATA_PANEL('Property','Value',...) creates a new DATA_PANEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Data_Panel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Data_Panel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Data_Panel

% Last Modified by GUIDE v2.5 25-Mar-2025 20:51:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Data_Panel_OpeningFcn, ...
                   'gui_OutputFcn',  @Data_Panel_OutputFcn, ...
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

% --- Executes just before Data_Panel is made visible.
function Data_Panel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Data_Panel (see VARARGIN)

% Choose default command line output for Data_Panel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Data_Panel wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = Data_Panel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


function edit_Upload_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Upload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Upload as text
%        str2double(get(hObject,'String')) returns contents of edit_Upload as a double
end

% --- Executes during object creation, after setting all properties.
function edit_Upload_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Upload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton_Upload.
function pushbutton_Upload_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Upload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = get(handles.edit_Upload,'string')
filePath = path;
data = readtable(filePath)
set(handles.uitable_showing,'Data',table2cell(data),'ColumnName', data.Properties.VariableNames)

% Get the numerical data
numericData = data(:, vartype('numeric'));
    if ~isempty(numericData)
        % Get the variable name
        varNames = numericData.Properties.VariableNames;

        % Part 1: Calculate the mean/variance/standard deviation
        % Calculate the mean value
        avgValues = varfun(@mean, numericData, 'OutputFormat', 'uniform');
        avgValuesStr = arrayfun(@(x) sprintf('%.0f', x), avgValues, 'UniformOutput', false);
        % Calculate the variance
        varValues = varfun(@var, numericData, 'OutputFormat', 'uniform');
        varValuesStr = arrayfun(@(x) sprintf('%.0f', x), varValues, 'UniformOutput', false);
        % Calculate the standard deviation
        stdValues = varfun(@std, numericData, 'OutputFormat', 'uniform');
        stdValuesStr = arrayfun(@(x) sprintf('%.0f', x), stdValues, 'UniformOutput', false);
        % Combaine the variable name and mean value
        resultData = [varNames', avgValuesStr',varValuesStr',stdValuesStr'];
        % Present the result
        set(handles.uitable_Mean, 'Data', resultData,'ColumnName', {'Variable', 'Average','Variance','Standard Deviation'});
        
        % Part 2: Draw the Histogram and Boxplot
        % Restore the data and variable name to handles
        handles.numericData = numericData;
        handles.numericVarNames = varNames;
        % Set the menu choice of Hisogram
        set(handles.popupmenu_Histogram, 'String', varNames, 'Value', 1);
        popupmenu_Histogram_Callback(handles.popupmenu_Histogram, eventdata, handles);
        % Set the menu choice of Boxplot
        set(handles.popupmenu_Boxplot, 'String', varNames, 'Value', 1);
        popupmenu_Boxplot_Callback(handles.popupmenu_Boxplot, eventdata, handles);

        % Part 3: Draw the Scatter plot
        set(handles.popupmenu_ScatterX, 'String', varNames, 'Value', 1);
        if length(varNames) >= 2
            set(handles.popupmenu_ScatterY, 'String', varNames, 'Value', 2);
        else
            set(handles.popupmenu_ScatterY, 'String', varNames, 'Value', 1);
        end
    else
        set(handles.uitable_average, 'Data', {}, 'ColumnName', {'Variable', 'Average','Variance','Standard Deviation'});
        set(handles.popupmenu_Histogram, 'String', {'No numeric variable'});
        set(handles.popupmenu_Boxplot, 'String', {'No numeric variable'});
    end
    guidata(hObject, handles);
end


% --- Executes on selection change in popupmenu_Histogram.
function popupmenu_Histogram_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Histogram contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Histogram
varNames = get(handles.popupmenu_Histogram, 'String');
idx = get(handles.popupmenu_Histogram, 'Value');
    % If no numerical variable
    if isempty(varNames) || strcmp(varNames{1}, 'No numeric variable')
        return;
    end
    % Set the selection name
    selectedVarName = varNames{idx};
    
    % 从保存的 numericData 中提取对应变量数据
    numericData = handles.numericData;
    selectedData = numericData.(selectedVarName);
    
    % Draw Histogram
    axes(handles.axes_Histogram);    
    h = histogram(selectedData);
    % Set X-axis
    edges = h.BinEdges;
    set(gca, 'XTick', edges, 'XTickMode', 'manual');

    % Set Y-axis
    binCenters = (h.BinEdges(1:end-1) + h.BinEdges(2:end)) / 2;
    % 获取每个 bin 的高度（计数值）
    counts = h.Values;
    % 在每个柱子上方添加文本
    for i = 1:length(counts)
        text(binCenters(i), counts(i), ...
            sprintf('%.0f', counts(i)), ...     % 显示整数格式
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom');
    end
    title(['Histogram of ' selectedVarName]);
end

% --- Executes during object creation, after setting all properties.
function popupmenu_Histogram_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu_Boxplot.
function popupmenu_Boxplot_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Boxplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Boxplot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Boxplot
varNames = get(handles.popupmenu_Boxplot, 'String');
idx = get(handles.popupmenu_Boxplot, 'Value');
    % If no numerical variable
    if isempty(varNames) || strcmp(varNames{1}, 'No numeric variable')
        return;
    end
    % Set the selection name
    selectedVarName = varNames{idx};
    
    % 从保存的 numericData 中提取对应变量数据
    numericData = handles.numericData;
    selectedData = numericData.(selectedVarName);
    
    % 绘制直方图
    axes(handles.axes_Boxplot);    % 切换到直方图的 Axes
    boxplot(selectedData);

    q1  = prctile(selectedData, 25);   % Q1
    med = median(selectedData);        % Median
    q3  = prctile(selectedData, 75);   % Q3
    mn  = mean(selectedData);    
 
    hold on;
    % 在图中标注
    offset = 0.1;  % X 方向上的偏移
    text(1+offset, q1,  sprintf('Q1=%.2f',   q1), 'VerticalAlignment','bottom');
    text(1+offset+0.15, med, sprintf('Median=%.2f', med), 'VerticalAlignment','bottom');
    text(1+offset, q3,  sprintf('Q3=%.2f',   q3), 'VerticalAlignment','bottom');
    text(1-offset, mn,  sprintf('Mean=%.2f', mn), 'HorizontalAlignment','right', 'VerticalAlignment','bottom');
    hold off;

    title(['Boxplot of ' selectedVarName]);

end

% --- Executes during object creation, after setting all properties.
function popupmenu_Boxplot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Boxplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in popupmenu_ScatterX.
function popupmenu_ScatterX_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ScatterX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ScatterX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ScatterX
end

% --- Executes during object creation, after setting all properties.
function popupmenu_ScatterX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ScatterX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu_ScatterY.
function popupmenu_ScatterY_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ScatterY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ScatterY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ScatterY
end

% --- Executes during object creation, after setting all properties.
function popupmenu_ScatterY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ScatterY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton_Scatter.
function pushbutton_Scatter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Scatter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % 获取下拉菜单中的变量名称
    varNames = get(handles.popupmenu_ScatterX, 'String');
    if isempty(varNames) || strcmp(varNames{1}, 'No numeric variable')
        errordlg('当前没有可用的数值型变量。','错误');
        return;
    end

    % 获取横轴和纵轴选中项
    idx_x = get(handles.popupmenu_ScatterX, 'Value');
    idx_y = get(handles.popupmenu_ScatterY, 'Value');

    % 得到对应的变量名称
    xVar = varNames{idx_x};
    yVar = varNames{idx_y};

    % 从保存的数值数据中提取数据
    numericData = handles.numericData;
    xData = numericData.(xVar);
    yData = numericData.(yVar);

    % 绘制散点图
    axes(handles.axes_Scatter);
    scatter(xData, yData, 'filled');
    xlabel(xVar);
    ylabel(yVar);
    title(['Scatter Plot of ' xVar ' vs ' yVar]);
end
