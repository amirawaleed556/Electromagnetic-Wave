
% The output of this code will illustrate the Propagation of Electric and Magnetic field 
function plane_wave
    ci=complex(0,1);    
    eps0=8.854e-12;     
    mu0=4.*pi.*1e-7;   
    c=2.99792458e8;   

    lambda0=1.;         
    freq=c./lambda0;    
    omega=2.*pi.*freq;  
    T=1./freq;        
    
    canvas_scale=1;   
    %----------------

    k0=omega.*sqrt(eps0.*mu0);  
    eta0=sqrt(mu0./eps0);       

   
    scrsz = get(groot,'ScreenSize');  
    canvas_width=(scrsz(3))*canvas_scale;
    canvas_height=(scrsz(4))*canvas_scale;
    font_size=(canvas_width/800)*12;    
    fig=figure('Position',[(scrsz(3)/2-canvas_width/2) (scrsz(4)/2-canvas_height/2) canvas_width canvas_height]);
  
    [X1,Y1] = meshgrid(0:1:0.1,-1.5:0.05:1.5);
    Z1 = 0.*(X1+Y1);
    
    [Z2,Y2] = meshgrid(0:1:0.1,-1.5:0.05:1.5);
    X2 = 0.*(X1+Y1);

    % Ex=Ey=0
    Ex=@(X,Y) 0.*(X1+Y1);
    Ey=@(X,Y) 0.*(X1+Y1);
    % Hz=Hy=0
    Hz=@(Y,Z) 0.*(Y2+Z2);
    Hy=@(Y,Z) 0.*(Y2+Z2);
    
    nframe=16;
    for i=1:nframe
        clf;       
        t=(T./nframe).*(i-1);

        Ez=@(X,Y) real(0.*(X1+Y1)+exp(-ci.*k0.*Y1).*exp(ci.*omega.*t));

        % Figure
        U=Ex(X1,Y1);
        V=Ey(X1,Y1);
        W=Ez(X1,Y1);
        h = quiver3(X1,Y1,Z1,U,V,W,2);
        set(h,'Color','r');
        axis equal;
        xlim([-1,1]);
        ylim([-1.5,1.5]);
        zlim([-1,1]);

        Hx=@(Y,Z) real(0.*(Y2+Z2)+0.8.*exp(-ci.*k0.*Y2).*exp(ci.*omega.*t));

        U=Hx(Y2,Z2);
        V=Hy(Y2,Z2);
        W=Hz(Y2,Z2);
        hold on;
        h = quiver3(X2,Y2,Z2,U,V,W,2);
        set(h,'Color','b');
        hold off;

        set(gca,'FontSize',font_size);  
        drawnow
        frm(i)=getframe(gcf);
    end
    movie(fig,frm,10);                
    
  
    v = VideoWriter('plane_wave.avi');
    v.FrameRate = 4;	% Default 30
    v.Quality = 75;     % Default 75
    open(v);
    nrep=3;            
    for k=1:nrep
        for i=1:nframe
            writeVideo(v,frm(i));
        end
    end
    close(v);
end


