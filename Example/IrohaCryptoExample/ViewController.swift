//
//  ViewController.swift
//  IrohaCryptoExample
//
//  Created by Ruslan Rezin on 17/10/2018.
//  Copyright © 2018 Ruslan Rezin. All rights reserved.
//

import UIKit
import IrohaCrypto

class ViewController: UIViewController {

    @IBOutlet private var messageTextView: UITextView!
    @IBOutlet private var privatePhraseTextView: UITextView!
    @IBOutlet private var privateKeyLabel: UILabel!
    @IBOutlet private var publicKeyLabel: UILabel!
    @IBOutlet private var signatureLabel: UILabel!

    private let keyFactory = IREd25519KeyFactory();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        reload()
    }

    private func reload() {
        guard let keypair = createKeypair() else {
            print("Can't create keypair!");
            return
        }

        let privateKeyString = keypair.privateKey().rawData().base64EncodedString()
        privateKeyLabel.text = privateKeyString

        let publicKeyString = keypair.publicKey().rawData().base64EncodedString()
        publicKeyLabel.text = publicKeyString

        guard let signer = IREd25519Sha512Signer(privateKey: keypair.privateKey()) else {
            print("Can't create signer from private key: \(privateKeyString)")
            return
        }

        guard let messageData = messageTextView.text.data(using: .utf8) else {
            print("Can't retrieve data to sign")
            return
        }

        guard let signature = signer.sign(messageData) else {
            print("Can't create signature for current message")
            return
        }

        let signatureString = signature.rawData().base64EncodedString()
        signatureLabel.text = signatureString
    }

    private func createKeypair() -> IRCryptoKeypairProtocol? {
        var optionalPrivateKey: IRPrivateKeyProtocol?

        if privatePhraseTextView.text.count > 0 {
            let optionalRawKey = privatePhraseTextView.text.data(using: .utf8)

            if let rawKey = (optionalRawKey as NSData?)?.sha3(sha256Variant) {
                optionalPrivateKey = IREd25519PrivateKey(rawData: rawKey)
            }
        }

        if let privateKey = optionalPrivateKey {
            return keyFactory.derive(fromPrivateKey: privateKey)
        } else {
            return keyFactory.createRandomKeypair()
        }
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        reload()
    }
}
