import UIKit
import WebKit

public class WebViewController: BaseViewController, WKNavigationDelegate, WKDownloadDelegate {
    
    private static let tag = "WebViewController"
    
    public static let intentParameterUrl = "url"
    public static let intentForceOpenInApp = "openInApp"
    
    public var urlString: String?
    public var forceOpenInApp: Bool = false
    
    private var webView: WKWebView!
    private var loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupWebView()
        setupNavigationBar()
        loadTargetUrl()
    }
    
    private func setupWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        
        // Кастомный User-Agent (эквивалент Android реализации)
        webView.customUserAgent = "Catrobat/1 iOS/1.0 Platform/Mobile"
        
        view.addSubview(webView)
        view.addSubview(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBackAction)
        )
    }
    
    private func loadTargetUrl() {
        let targetString = urlString ?? "https://share.catrobat.org"
        if let url = URL(string: targetString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // MARK: - WKNavigationDelegate
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        print("[\(WebViewController.tag)] WebView failed to load with error: \(error.localizedDescription)")
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        // Обработка внешних ссылок или мессенджеров (например, WhatsApp)
        if url.scheme == "whatsapp" {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}
