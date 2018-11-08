function Mirrored_Word_Offline_1()

% Mirrored Word Reading Paradigm used for offline data collection

ISI=0.2; % time between words
wordtime=1; % word presentation time
evalin('base','load words_desktop'); % Load dictionary whose words are at least 5 letters long
evalin('base','clear global');
evalin('base','global rows');
evalin('base','global cols');
evalin('base','global natural');
evalin('base','global mirrored');
global rows
global cols
global natural
global mirrored
natural_order=randperm(length(natural));
mirrored_order=randperm(length(mirrored));
trials=5;
%trials=length(natural_order);
gui_position=[0 0 0.8 0.8];

instruction_text='Instructions: Read the words that appear on the center of the screen and avoid blinking. Please click "START" when you are ready to begin';

set_param('EEG_Data_Collection_offline/BCI/START SIGNAL','Value','0');
set_param('EEG_Data_Collection_offline/BCI/WORD','Value','0');
set_param('EEG_Data_Collection_offline/BCI/ORIENTATION','Value','0');
f = figure('Color','black','Menubar','none','Visible','off','Name','The University of the West Indies Brain-Computer Interface Group: Offline Mirrored-Word Reading Paradigm','Units','Normalized','Position',gui_position,'Toolbar','none','NumberTitle','off');
set(f,'CloseRequestFcn',@close_function);
set(f,'Visible','on');

instructions=uicontrol('Parent',f,'Units','Normalized','Style','text','String',instruction_text,'Position',[0.1,0.35,0.80,0.30],'FontName','Arial','ForegroundColor',[1 1 1],'BackgroundColor',[0 0 0],'FontSize',40,'HorizontalAlignment','center');
hbutton = uicontrol('Parent',f,'Style','pushbutton','Units','Normalized','String','START','Position',[0.4,0.01,0.2,0.05],'ForegroundColor',[1 1 1],'BackgroundColor',[0 0 0],'callback',@hbutton_callback,'FontSize',20);

    function close_function(source,eventdata)
        set_param('EEG_Data_Collection_offline/BCI/START SIGNAL','Value','1');
        set_param('EEG_Data_Collection_offline','SimulationCommand','stop');
        clear global % Clear global variables on closing the GUI window
        delete(f); % get rid of created figure (GUI)
    end

    function hbutton_callback(source,eventdata)
        
        %set_param('EEG_Data_Collection_offline','SimulationCommand','start');
        set(hbutton,'Visible','off'); % Disable START BUTTON during presentation
        set(instructions,'Visible','off');
        myWait(2);
        
        for trial=1:trials
            
            set_param('EEG_Data_Collection_offline/BCI/WORD','Value','1'); % WORD=1 indicates word is present on screen
            set_param('EEG_Data_Collection_offline/BCI/ORIENTATION','Value','1'); % ORIENTATION=1 indicates natural word
            natural_image=uint8(zeros(rows,cols));
            natural_image(natural{natural_order(trial)})=255;
            
            left_word_boundary=floor(min(find(natural_image==255)/rows)); % Center image horizontally on screen
            right_word_boundary=floor(max(find(natural_image==255)/rows));
            dist_to_left=left_word_boundary;
            dist_to_right=cols-right_word_boundary;
            if dist_to_right > dist_to_left
                adjustment=floor((dist_to_right-dist_to_left)/2);
                natural_image=[ zeros(rows,adjustment) natural_image(:,1:end-adjustment)];
            else
                adjustment=floor((dist_to_left-dist_to_right)/2);
                natural_image=[ natural_image(:,adjustment+1:end) zeros(rows,adjustment)];
            end
            
            imshow(natural_image,'InitialMagnification','fit');
            myWait(wordtime);
            
            imshow('black.bmp','InitialMagnification','fit');
            set_param('EEG_Data_Collection_offline/BCI/ORIENTATION','Value','0');
            set_param('EEG_Data_Collection_offline/BCI/WORD','Value','0'); % WORD=0 indicates no word is present on screen
            myWait(ISI); % Inter-stimulus interval
            
            set_param('EEG_Data_Collection_offline/BCI/WORD','Value','1'); % WORD=1 indicates word is present on screen
            set_param('EEG_Data_Collection_offline/BCI/ORIENTATION','Value','2'); % ORIENTATION=2 indicates reverse word
            mirrored_image=uint8(zeros(rows,cols));
            mirrored_image(mirrored{mirrored_order(trial)})=255;
            
            left_word_boundary=floor(min(find(mirrored_image==255)/rows)); % Center image horizontally on screen
            right_word_boundary=floor(max(find(mirrored_image==255)/rows));
            dist_to_left=left_word_boundary;
            dist_to_right=cols-right_word_boundary;
            if dist_to_right > dist_to_left
                adjustment=floor((dist_to_right-dist_to_left)/2);
                mirrored_image=[ zeros(rows,adjustment) mirrored_image(:,1:end-adjustment)];
            else
                adjustment=floor((dist_to_left-dist_to_right)/2);
                mirrored_image=[ mirrored_image(:,adjustment+1:end) zeros(rows,adjustment)];
            end
            
            imshow(mirrored_image,'InitialMagnification','fit');
            myWait(wordtime);
            
            imshow('black.bmp','InitialMagnification','fit');
            set_param('EEG_Data_Collection_offline/BCI/ORIENTATION','Value','0');
            set_param('EEG_Data_Collection_offline/BCI/WORD','Value','0'); % WORD=0 indicates no word is present on screen
            myWait(ISI); % Inter-stimulus interval
            
            clf(f); % clear the figure
            
        end
        
        myWait(2);
        set_param('EEG_Data_Collection_offline','SimulationCommand','stop');
        final_message=uicontrol('Parent',f,'Units','Normalized','Style','text','String','The experiment has now ended. Thank you for your participation.','Position',[0.1,0.35,0.80,0.30],'FontName','Arial','ForegroundColor',[1 1 1],'BackgroundColor',[0 0 0],'FontSize',40,'HorizontalAlignment','center');
        
    end

movegui(f,'center');
set(f,'Visible','on');

end