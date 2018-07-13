import {
    NativeModules,
    NativeEventEmitter
} from 'react-native';

const { Agora } = NativeModules
const agoraEmitter = new NativeEventEmitter(Agora);

export default {
    ...Agora,
    init(options = {}) {
        this.listener && this.listener.remove();
        Agora.init(options);
    },
    joinChannel(channelName = '00001', uid = 0) {
        Agora.joinChannel(channelName, uid);
    },
    eventEmitter(fnConf) {
        this.removeEmitter();
        this.listener = agoraEmitter.addListener(
            'agoraEvent',
            (event) => {
                fnConf[event['type']] && fnConf[event['type']](event);
            }
        );
    },
    removeEmitter() {
        this.listener && this.listener.remove();
        this.listener = null;
    }
};
