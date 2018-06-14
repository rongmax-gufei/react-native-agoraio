import  React, {Component} from 'react'
import {PropTypes} from 'prop-types'
import {
    requireNativeComponent,
    View,
    Platform
} from 'react-native'

export default class AgoraScreenShareView extends Component {

    render() {
        return (
            <RCTAgoraScreenShareView {...this.props}/>
        )
    }
}

AgoraScreenShareView.propTypes = {
    showSharedScreen: PropTypes.bool,
    zOrderMediaOverlay: PropTypes.bool,
    ...View.propTypes
};

const RCTAgoraScreenShareView = requireNativeComponent("RCTAgoraScreenShareView", AgoraScreenShareView);
