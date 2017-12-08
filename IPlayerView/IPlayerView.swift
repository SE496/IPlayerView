/*
 MIT License
 
 Copyright (c) 2017 Sarim Ashfaq
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */


import UIKit
import Player

protocol IPlayerViewDelegate {
    
}

class IPlayerView: UIView {

    fileprivate var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    fileprivate var muteBtn = UIButton(type: UIButtonType.custom)
    fileprivate var player = Player()
    var delegate: IPlayerViewDelegate? = nil
    
    deinit {
        self.player.view.removeFromSuperview()
        self.player.removeFromParentViewController()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(frame)
        setupIPlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupIPlayer()
    }
    
    open func playVideo(videoURL: String){
        self.player.url = URL(string: videoURL)
        self.player.playbackLoops = true
        self.player.playFromBeginning()
        activityIndicator.startAnimating()
    }
    
    open func stopVideo(){
        self.player.stop()
        self.player.url = nil
    }
    
    private func setupIPlayer(){
        setupPlayerView()
        setupActivityIndicator()
        setupButton()
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //sideSpacing is space of UIView from its right + left sides of superview
    //width = UIScreen.main.bounds.width when using square view
    private func setupPlayerView(){
        let sideSpacing: CGFloat = 0.0
        self.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width - sideSpacing, height: UIScreen.main.bounds.width - sideSpacing)
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.player.view.frame = self.bounds
        self.player.view.clipsToBounds = true
        player.fillMode = PlayerFillMode.resizeAspectFill.avFoundationType
        player.layerBackgroundColor = UIColor.white
        self.addSubview(self.player.view)
    }
    
    private func setupButton(){
        muteBtn.setImage(#imageLiteral(resourceName: "unMuteSpeaker.png"), for: .normal)
        muteBtn.setImage(#imageLiteral(resourceName: "muteSpeaker.png"), for: .selected)
        muteBtn.frame = CGRect(x: 8.0, y: player.view.frame.maxY - 38.0, width: 30.0, height: 30.0)
        muteBtn.addTarget(self, action: #selector(self.muteAction(_:)), for: .touchUpInside)
        self.addSubview(muteBtn)
    }
    
    private func setupActivityIndicator(){
        activityIndicator.color = UIColor.black
        activityIndicator.center = player.view.center
        self.addSubview(activityIndicator)
    }
    
    @objc private func muteAction(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false:true
        player.muted = sender.isSelected
    }
    
    open func setButtonRect(x: CGFloat?, y: CGFloat?, width: CGFloat?, height: CGFloat?){
        muteBtn.frame = CGRect(x: x ?? 8.0, y: y ?? player.view.frame.maxY - 38.0, width: width ?? 30.0, height: height ?? 30.0)
    }
    
    open func setButtonImages(defaultImage: UIImage, selectedImage: UIImage){
        muteBtn.setImage(defaultImage, for: .normal)
        muteBtn.setImage(selectedImage, for: .selected)
    }
    
    
}

// MARK: - UIGestureRecognizer

extension IPlayerView {
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        switch (self.player.playbackState.rawValue) {
        case PlaybackState.stopped.rawValue:
            self.player.playFromBeginning()
            break
        case PlaybackState.paused.rawValue:
            self.player.playFromCurrentTime()
            break
        case PlaybackState.playing.rawValue:
            self.player.pause()
            break
        case PlaybackState.failed.rawValue:
            self.player.pause()
            break
        default:
            self.player.pause()
            break
        }
    }
    
}

extension IPlayerView:PlayerDelegate {
    
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        if player.bufferingState == .ready {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
}

// MARK: - PlayerPlaybackDelegate

extension IPlayerView:PlayerPlaybackDelegate {
    
    func playerCurrentTimeDidChange(_ player: Player) {
        
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
}
