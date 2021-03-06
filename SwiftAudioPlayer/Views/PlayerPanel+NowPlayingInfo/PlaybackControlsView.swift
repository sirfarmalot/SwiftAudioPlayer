//
//  PlaybackControlsView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa
import MediaPlayer

protocol PlaybackControlsDelegate {
  func playPause(sender: NSButton)
  func next(sender: NSButton)
  func prev(sender: NSButton)
  func showVolumeControl(sender: NSButton)
}

class PlaybackControlsView: NSStackView {
  
  private let remoteCommandCenter = MPRemoteCommandCenter.shared()
  let notificationCenter = NotificationCenter.default
  var playbackControlsDelegate: PlaybackControlsDelegate?
  
  lazy var playPauseButton: ImageButton = {
    let image = NSImage(named: NSImage.touchBarPlayTemplateName)
    let scaling = NSImageScaling.scaleProportionallyUpOrDown
    let button = ImageButton(image: image!, width: 40, height: 40, scaling: scaling)
    button.target = self
    button.action = #selector(handlePlayPause)
    return button
  }()
  
  lazy var prevButton: ImageButton = {
    let image = NSImage(named: NSImage.touchBarSkipBackTemplateName)
    let button = ImageButton(image: image!)
    button.target = self
    button.action = #selector(handlePrev)
    return button
  }()
  
  lazy var nextButton: ImageButton = {
    let image = NSImage(named: NSImage.touchBarSkipAheadTemplateName)
    let button = ImageButton(image: image!)
    button.target = self
    button.action = #selector(handleNext)
    return button
  }()
  
  lazy var shuffleButton: ImageButton = {
    let image = NSImage(named: NSImage.touchBarShareTemplateName)
    let button = ImageButton(image: image!, width: 24, height: 24)
    button.target = self
    return button
  }()
  
  lazy var repeatButton: ImageButton = {
    let image = NSImage(named: NSImage.touchBarRefreshTemplateName)
    let button = ImageButton(image: image!, width: 24, height: 24)
    button.target = self
    return button
  }()
  
  lazy var volumeButton: ImageButton = {
    let image = NSImage(named: NSImage.touchBarAudioOutputVolumeHighTemplateName)
    let button = ImageButton(image: image!, width: 24, height: 24)
    button.target = self
    button.action = #selector(handleShowVolumeControl(sender:))
    return button
  }()
  
  lazy var infoButton: ImageButton = {
    let image = NSImage(named: NSImage.touchBarGetInfoTemplateName)
    let button = ImageButton(image: image!, width: 24, height: 24)
    button.target = self
    return button
  }()
  
  lazy var leadingViews: [NSView] = [
    shuffleButton,
    repeatButton,
    SpacerView(minSize: 16, maxSize: 64)
  ]
  lazy var centerViews: [NSView] = [
    prevButton,
    playPauseButton,
    nextButton
  ]
  lazy var trailingViews: [NSView] = [
    SpacerView(minSize: 16, maxSize: 64),
    volumeButton,
    infoButton
  ]
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupStackView()
    setupViews()
    setupObserver()
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupStackView() {
    orientation = .horizontal
    spacing = 8
    edgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    translatesAutoresizingMaskIntoConstraints = false
    setClippingResistancePriority(.defaultLow, for: .horizontal)
  }
  
  private func setupViews() {
    leadingViews.forEach {
      addView($0, in: .leading)
      setVisibilityPriority(NSStackView.VisibilityPriority.detachOnlyIfNecessary, for: $0)
    }
    centerViews.forEach {
      addView($0, in: .center)
      setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: $0)
    }
    trailingViews.forEach {
      addView($0, in: .trailing)
      setVisibilityPriority(NSStackView.VisibilityPriority.detachOnlyIfNecessary, for: $0)
    }
  }
  
  private func setupObserver() {
    notificationCenter.addObserver(self,
                                   selector: #selector(handlePlaybackStarted),
                                   name: .playbackStarted,
                                   object: nil
    )
    notificationCenter.addObserver(self,
                                   selector: #selector(handlePlaybackPausedOrStopped),
                                   name: .playbackPaused,
                                   object: nil
    )
    notificationCenter.addObserver(self,
                                   selector: #selector(handlePlaybackPausedOrStopped),
                                   name: .playbackStopped,
                                   object: nil
    )
  }
  
  @objc private func handlePlaybackStarted() {
    playPauseButton.image = NSImage(named: NSImage.touchBarPauseTemplateName)
  }
  
  @objc private func handlePlaybackPausedOrStopped() {
    playPauseButton.image = NSImage(named: NSImage.touchBarPlayTemplateName)
  }
  
  @objc private func handleShowVolumeControl(sender: NSButton) {
    playbackControlsDelegate?.showVolumeControl(sender: volumeButton)
  }
  
  @objc private func handleMuteVolume() {
    print("mute")
  }
  
  @objc private func handlePlayPause() {
    playbackControlsDelegate?.playPause(sender: playPauseButton)
  }
  
  @objc private func handleNext() {
    playbackControlsDelegate?.next(sender: nextButton)
  }
  
  @objc private func handlePrev() {
    playbackControlsDelegate?.prev(sender: prevButton)
  }
}
