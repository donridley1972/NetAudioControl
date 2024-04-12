namespace claAudio
{
    partial class AudioControl
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.waveformPainter1 = new NAudio.Gui.WaveformPainter();
            this.waveformPainter2 = new NAudio.Gui.WaveformPainter();
            this.volumeMeter1 = new NAudio.Gui.VolumeMeter();
            this.volumeMeter2 = new NAudio.Gui.VolumeMeter();
            this.SuspendLayout();
            // 
            // waveformPainter1
            // 
            this.waveformPainter1.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.waveformPainter1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
            this.waveformPainter1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(192)))), ((int)(((byte)(0)))));
            this.waveformPainter1.Location = new System.Drawing.Point(0, 0);
            this.waveformPainter1.Name = "waveformPainter1";
            this.waveformPainter1.Size = new System.Drawing.Size(742, 93);
            this.waveformPainter1.TabIndex = 0;
            this.waveformPainter1.Text = "waveformPainter1";
            // 
            // waveformPainter2
            // 
            this.waveformPainter2.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.waveformPainter2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
            this.waveformPainter2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(192)))), ((int)(((byte)(0)))));
            this.waveformPainter2.Location = new System.Drawing.Point(0, 97);
            this.waveformPainter2.Name = "waveformPainter2";
            this.waveformPainter2.Size = new System.Drawing.Size(742, 93);
            this.waveformPainter2.TabIndex = 1;
            this.waveformPainter2.Text = "waveformPainter2";
            // 
            // volumeMeter1
            // 
            this.volumeMeter1.Amplitude = 0F;
            this.volumeMeter1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.volumeMeter1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(192)))), ((int)(((byte)(0)))));
            this.volumeMeter1.Location = new System.Drawing.Point(751, 0);
            this.volumeMeter1.MaxDb = 18F;
            this.volumeMeter1.MinDb = -60F;
            this.volumeMeter1.Name = "volumeMeter1";
            this.volumeMeter1.Size = new System.Drawing.Size(20, 191);
            this.volumeMeter1.TabIndex = 2;
            this.volumeMeter1.Text = "volumeMeter1";
            // 
            // volumeMeter2
            // 
            this.volumeMeter2.Amplitude = 0F;
            this.volumeMeter2.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.volumeMeter2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(192)))), ((int)(((byte)(0)))));
            this.volumeMeter2.Location = new System.Drawing.Point(777, 0);
            this.volumeMeter2.MaxDb = 18F;
            this.volumeMeter2.MinDb = -60F;
            this.volumeMeter2.Name = "volumeMeter2";
            this.volumeMeter2.Size = new System.Drawing.Size(20, 191);
            this.volumeMeter2.TabIndex = 3;
            this.volumeMeter2.Text = "volumeMeter2";
            // 
            // AudioControl
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
            this.Controls.Add(this.volumeMeter2);
            this.Controls.Add(this.volumeMeter1);
            this.Controls.Add(this.waveformPainter2);
            this.Controls.Add(this.waveformPainter1);
            this.Name = "AudioControl";
            this.Size = new System.Drawing.Size(800, 192);
            this.SizeChanged += new System.EventHandler(this.AudioControl_SizeChanged);
            this.Resize += new System.EventHandler(this.AudioControl_Resize);
            this.ResumeLayout(false);

        }

        #endregion

        private NAudio.Gui.WaveformPainter waveformPainter1;
        private NAudio.Gui.WaveformPainter waveformPainter2;
        private NAudio.Gui.VolumeMeter volumeMeter1;
        private NAudio.Gui.VolumeMeter volumeMeter2;
    }
}

