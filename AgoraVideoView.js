import  React, {Component} from 'react'
import {PropTypes} from 'prop-types'
import {
    requireNativeComponent,
    View,
    Platform
} from 'react-native'

export default class AgoraVideoView extends Component {

    render() {
        return (
            <RCTAgoraVideoView {...this.props}/>
        )
    }
}

AgoraVideoView.propTypes = {
    showLocalVideo: PropTypes.bool,
    remoteUid: PropTypes.number,
    renderUid: PropTypes.number,
    zOrderMediaOverlay: PropTypes.bool,
    ...View.propTypes
};

const RCTAgoraVideoView = requireNativeComponent("RCTAgoraVideoView", AgoraVideoView);
